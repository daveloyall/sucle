(in-package :sandbox)

(progn
  (defstruct node
    prev
    next
    payload)
  (progn
    (defparameter *node-print-depth* (ash 2 (if t 7 4)))
    (defun pprint-node (stream node)
      (pprint-logical-block (stream nil)
	(print-unreadable-object (node stream :type nil :identity nil)
	  (dotimes (x *node-print-depth*)
	    (format stream "~a" (node-payload node))
	    (let ((next (node-next node)))
	      (if (typep next (quote node))
		  (progn
		    (setf node next))
		  (return)))))))
    (set-pprint-dispatch (quote node) (quote pprint-node)))
  (progn
    (defun link-nodes (prev-node next-node)
      (setf (node-next prev-node) next-node
	    (node-prev next-node) prev-node))
    (defun disconnect-node (node)
      (let ((prev (node-prev node))
	    (next (node-next node)))
	(setf (node-next node) nil
	      (node-prev node) nil)
	(when (typep prev (quote node))
	  (setf (node-next prev) next))
	(when (typep next (quote node))
	  (setf (node-prev next) prev))))
    (defun disconnect-node-prev (node)
      (let ((prev (node-prev node)))
	(setf (node-prev node) nil)
	(when (typep prev (quote node))
	  (setf (node-next prev) nil)))
      node)
    (defun disconnect-node-next (node)
      (let ((next (node-next node)))
	(setf (node-next node) nil)
	(when (typep next (quote node))
	  (setf (node-prev next) nil)))
      node)
    (defun string-nodes (string &optional (base (load-time-value (make-node))))
      (let ((prev-node base))
	(let ((len (length string)))
	  (dotimes (index len)
	    (let ((char (aref string index)))
	      (let ((new-node (make-node :payload char)))
		(link-nodes prev-node new-node)
		(setf prev-node new-node))))
	  (let ((start (node-next base)))
	    (disconnect-node base)
	    (link-nodes prev-node start)
	    (values start
		    len)))))
    (defun splice-nodes (prev next)
      (let ((otherprev (node-prev next))
	    (othernext (node-next prev)))
	(link-nodes otherprev othernext)
	(link-nodes prev next)))))

(defstruct payload
  metadata
  data)
(progn
  (defun pprint-payload (stream payload)
    (pprint-logical-block (stream nil)
      (let ((meta (payload-metadata payload)))
	(format stream "~a"
		(case meta
		  (left "[")
		  (right "]"))))))
  (set-pprint-dispatch (quote payload) (quote pprint-payload)))

(defstruct bracket
  object
  (width 0 :type fixnum)
  left
  right)

(progn
  (defstruct hole
    (width 0 :type fixnum)
    active
    (motion 0 :type fixnum)
    generator
    indentation-func)
  (defun hole-type (hole)
    (let ((gen-func (hole-generator hole)))
      (if (functionp gen-func)
	  (funcall gen-func (quote info))
	  gen-func)))
  (progn
    (defun pprint-hole (stream hole)
      (pprint-logical-block (stream nil)
	(let ((width (hole-width hole)))
	  (format stream "<~a ~a ~a ~a>" (if (hole-active hole) #\@ #\#) width (hole-motion hole)
		  (hole-type hole)))))
    (set-pprint-dispatch (quote hole) (quote pprint-hole)))
  (progn
    (defun deactivate-hole (hole)
      (when (hole-active hole)
	(incf (hole-motion hole) (hole-width hole))
	(setf (hole-active hole) nil)))
    (defun activate-hole (hole)
      (unless (hole-active hole)
	(decf (hole-motion hole) (hole-width hole))
	(setf (hole-active hole) t)))))

(defun print-to-buf (object)
  (let ((buffer (load-time-value
		 (make-array 0 :fill-pointer 0 :adjustable t :element-type (quote character)))))
    (setf (fill-pointer buffer) 0)
    (with-output-to-string (var buffer)
      (prin1 object var))
    buffer))

(defun gen-brackets (data2 width)
  (let ((left-payload (make-payload :metadata (quote left)))
	(right-payload (make-payload :metadata (quote right))))
    (let ((left-bracket (make-node :payload left-payload))
	  (right-bracket (make-node :payload right-payload)))
      (let ((middle (make-bracket :left left-bracket
				  :right right-bracket
				  :object data2
				  :width width)))
	      (setf (payload-data left-payload) middle
		    (payload-data right-payload) middle))
      (link-nodes left-bracket right-bracket)
      (link-nodes right-bracket left-bracket)
      left-bracket)))

(defun enbracket (a data2 width)
  (let ((brackets (gen-brackets data2 width)))
    (splice-nodes brackets a)
    brackets))

(defun emit-cons (cell)
  (let ((base nil))
    (let ((last-node base))
      (let ((total-width 0))
	(labels ((add (new bracket-payload width)
		   (add-no-bracket (enbracket new
					      bracket-payload
					      width)))
		 (add-no-bracket (new)
		   (let ((next-base (node-prev new)))
		     (if last-node
			 (progn
			   (let ((hole (gen-hole)))
			     (add-hole hole))
			   (splice-nodes last-node new))
			 (setf base new))
		     (setf last-node next-base)))
		 (add-hole (new)
		   (let ((next-base (node-prev new)))
		     (splice-nodes last-node new)
		     (setf last-node next-base))))
	  (let ((car (car cell))
		(cdr (cdr cell)))
	    (let ((data (cons (quote car) cell))
		  (width 0))
	      (flet ((string-nodes (string)
		       (multiple-value-bind (nodes length) (string-nodes string)
			 (incf width length)
			 (add nodes data width))))
		(if (listp car)
		    (if car
			(progn
			  (string-nodes "(")
			  (multiple-value-bind (nodes length) (emit-cons car)
			    (incf width length)
			    (add-no-bracket nodes)))
			(string-nodes "nil"))
		    (string-nodes (print-to-buf car))))
	      (incf total-width width))
	    (let ((data (cons (quote cdr) cell))
		  (width 0))
	      (flet ((string-nodes (string)
		       (multiple-value-bind (nodes length) (string-nodes string)
			 (incf width length)
			 (add nodes data width))))
		(let ((list-cdr-p nil))
		  (if (listp cdr)
		      (if cdr
			  (progn
			    (string-nodes " ")
			    (setf list-cdr-p t))
			  (string-nodes ")"))
		      (error "~a" "dotted list"))
		  (incf total-width width)
		  (let ((newbase (enbracket base 
					    (cons (quote cons) cell)
					    total-width)))
		    (setf base newbase)
		    (setf last-node (node-prev newbase)))
		  (when list-cdr-p
		    (multiple-value-bind (nodes length) (emit-cons cdr)
		      (incf total-width length)
		      (add-no-bracket nodes))))))))
	(values base
		total-width)))))

(defun gen-hole ()
  (let ((hole (make-hole :width 0 :active nil)))
    (let ((node (make-node :payload hole)))
      (link-nodes node node)
      node)))

;;walking
(defun draw-nodes2 (x y node &optional (cap 1024))
  (dotimes (index cap)
    (if node
	(progn (let ((payload (node-payload node)))
		 (typecase payload
		   (character (scwu node x y) (incf x))
		   (hole
		    (update-whole-hole node)
		    (when (hole-active payload)
		      (decf y 1)
		      (incf x (hole-width payload))))))
	       (setf node (node-next node)))
	(return))))

;;walking
(defun draw-nodes2-reverse (x y node &optional (cap 1024))
  (dotimes (index cap) 
    (if node
	(progn (let ((payload (node-payload node)))
		 (typecase payload
		   (character (scwu node x y) (decf x))
		   (hole
		    (update-whole-hole node)
		    (when (hole-active payload)
		      (incf y 1)
		      (decf x (hole-width payload))))))
	       (setf node (node-prev node)))
	(return))))

;;;;walking
(defun jump-block-left (node)
  (bracket-left (payload-data (node-payload node))))
(defun jump-block-right (node)
  (bracket-right (payload-data (node-payload node))))

;;;walking
(defun find-enclosing-block-left (node)
  (block nil
    (if node
	(let ((payload (node-payload node)))
	  (if (typep payload (quote payload))
	      (let ((side (payload-metadata payload)))
		(if (eq (quote left) side)
		    (return (payload-data payload))
		    (if (eq (quote right) side)
			(setf node (jump-block-left node))))))
	  (find-enclosing-block-left (node-prev node))))))


;;;;propagate width changes to enclosing brackets, stopping when reaching
;;;;an active newline
(defun width-prop (node)
  (let* ((hole (node-payload node))
	 (motion (hole-motion hole)))
    (unless (zerop motion)
      (setf (hole-motion hole) 0)
      (labels ((%width-prop (node value)
		 (when node
		   (let ((payload (node-payload node)))
		     (typecase payload
		       (hole (if (hole-active payload)
				 (incf (hole-width payload) value)
				 (incf (hole-motion payload) value))
			     node)
		       (payload
			(case (payload-metadata payload)
			  (left (%width-prop (node-next (jump-block-right node))
					     value))
			  (right (let ((bracket (payload-data payload)))
				   (decf (bracket-width bracket) value))
				 (%width-prop (node-next node) value))))
		       (t (%width-prop (node-next node) value))))))) 
	(%width-prop (node-next node) motion)))))


(defun find-parent-hole (node)
  (%find-parent-hole (node-prev node) 0))
(defun %find-parent-hole (node depth)
  (when node
    (let ((payload (node-payload node)))
      (typecase payload
	(hole (values node depth))
	(payload
	 (case (payload-metadata payload)
	   (right (%find-parent-hole (node-prev (jump-block-left node)) depth))
	   (left (%find-parent-hole (node-prev node) (1+ depth)))))
	(t (%find-parent-hole (node-prev node) depth))))))

(defparameter *no-indent*
  (lambda (node-hole) (declare (ignorable node-hole)) (values 0 nil)))
(progn
  (defparameter *null-parent* nil)
  (setf *null-parent*
	(lambda (child-type &optional child)
	  (declare (ignorable child))
	  (case child-type
	    (car (values *null-parent* *no-indent*))
	    (cdr (values *null-parent* *no-indent*))
	    (info "void")
	    (otherwise (error "child not car or cdr: ~a" child-type))))))

(defun update-hole-indentation-func (node)
  (multiple-value-bind (parent depth) (find-parent-hole node)
    (when parent
      (let ((parent-hole (node-payload parent)))
	(let ((parent-type (hole-generator parent-hole)))
	  (flet ((gen-child (child parent-type depth)
		   (let ((value (ecase depth
				  (0 (quote cdr))
				  (1 (quote car))
				  (otherwise (error "depth not 0 or 1: ~a" depth)))))
		     (if parent-type
			 (funcall parent-type value child)
			 (funcall *null-parent* value child)))))
	    (multiple-value-bind (child-type function)
		(gen-child node parent-type depth)
	      (let ((hole (node-payload node)))
		(setf (hole-indentation-func hole) function
		      (hole-generator hole) child-type)))))))))
(defun reindent-hole (node)
  (let ((hole (node-payload node)))
    (let ((func (hole-indentation-func hole)))
      (multiple-value-bind (width active) (if func (funcall func node) (values 0 nil))
	(set-hole-state hole active)
	(set-hole-width width hole)))))
(defun set-hole-state (hole state)
  (if state
      (activate-hole hole)
      (deactivate-hole hole)))
(defun set-hole-width (new-width hole)
  (when (hole-active hole)     	
    (decf (hole-motion hole)
	  (- new-width (hole-width hole))))
  (setf (hole-width hole) new-width))

(defun update-whole-hole (node)
  (when node
    (update-hole-indentation-func node)
    (reindent-hole node)
    (width-prop node)))

(defun zerofy-hole (hole)
  (set-hole-width 0 hole)
  (set-hole-state hole nil)
  (setf (hole-indentation-func hole) nil
	(hole-generator hole) nil))

(defun gen-hole-spread-func (&key
			       (name (random most-positive-fixnum))
			       ((:car inner-func) *null-parent*)
			       ((:cdr outer-func) *null-parent*)
			       &allow-other-keys)
  (lambda (child-type &optional child)
    (ecase child-type
      (car (funcall inner-func child))
      (cdr (funcall outer-func child))
      (info name)
      (otherwise (error "child not car or cdr: ~a" child-type)))))

(defun set-hole-type (hole type)
  (multiple-value-bind (rules exists-p) (get-hole-generator type)
    (if exists-p
	(setf (hole-indentation-func hole) *no-indent*
	      (hole-generator hole) rules)
	(error "hole type does not exist: ~a" type))))

(defun allow-indentation-outside-cons-cells (node)
  (block yolo-baggins
    (flet ((punt () (return-from yolo-baggins (values 0 nil))))
      (let* ((left (or (node-prev node) (punt)))
	     (right (or (node-next node) (punt)))
	     (left-payload (node-payload left))
	     (right-payload (node-payload right))
	     (left-type (car (bracket-object (payload-data left-payload))))
	     (right-type (car (bracket-object (payload-data right-payload)))))
	(if (and (eq left-type (quote cons))
		 (eq right-type (quote cons)))
	    (values (- (bracket-width (payload-data left-payload))) t)
	    (values 0 nil))))))

(defun define-indentation-rule (&rest args)
  (let ((function	   
	 (apply (function gen-hole-spread-func) args)))
    (print args)
    (setf (get-hole-generator (getf args :name)) function)))

;;;;ftype (function (child) (values spread-function width-function)) value
(progn
  (defparameter *generator-rules* (make-hash-table :test (quote eq)))
  (defun get-hole-generator (name)
    (gethash name *generator-rules*))
  (defun (setf get-hole-generator) (value name)
    (setf (gethash name *generator-rules*) value)))

(define-indentation-rule
    :name (quote form)
    :car (lambda (node)
	   (declare (ignorable node))
	   (values (get-hole-generator (quote form))
		   (function allow-indentation-outside-cons-cells)))
    :cdr (lambda (node)
	   (declare (ignorable node))
	   (values (get-hole-generator (quote form))
		   (function allow-indentation-outside-cons-cells))))
