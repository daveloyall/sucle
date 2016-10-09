(in-package #:mat)


(defun fourbyfour (initial-contents)
  (let ((intermed
	 (%aux%% initial-contents
		 (lambda (x) (coerce x 'single-float)))))
    (make-array '(4 4)
		:element-type 'single-float
		:initial-contents intermed)))

(defun onebyfour (contents)
  (make-array '(1 4) :initial-contents (list contents)))

(defun fourbyone (contents)
  (make-array '(4 1) :initial-contents
	      (list
	       (list (first contents))
	       (list (second contents))
	       (list (third contents))
	       (list (fourth contents)))))

(defun %aux%% (dalist func)
  (if dalist
      (if (atom dalist)
	  (funcall func dalist)
	  (cons
	   (%aux%% (car dalist) func)
	   (%aux%% (cdr dalist) func)))
      nil))

(defun get-lookat (right up direction position)
  (let* ((rx (row-major-aref right 0))
	 (ry (row-major-aref right 1))
	 (rz (row-major-aref right 2))
	 (ux (row-major-aref up 0))
	 (uy (row-major-aref up 1))
	 (uz (row-major-aref up 2))
	 (dx (row-major-aref direction 0))
	 (dy (row-major-aref direction 1))
	 (dz (row-major-aref direction 2))
	 (px (row-major-aref position 0))
	 (py (row-major-aref position 1))
	 (pz (row-major-aref position 2)))
    (fourbyfour
     (matrix-multiply
      (list (list rx ry rz 0)
	    (list ux uy uz 0)
	    (list dx dy dz 0)
	    (list 0 0 0 1))
      (list (list 1 0 0 (- px))
	    (list 0 1 0 (- py))
	    (list 0 0 1 (- pz))
	    (list 0 0 0 1))))))

(defun cross (u v)
  (let* ((u1 (row-major-aref u 0))
	 (u2 (row-major-aref u 1))
	 (u3 (row-major-aref u 2))
	 (v1 (row-major-aref v 0))
	 (v2 (row-major-aref v 1))
	 (v3 (row-major-aref v 2)))
    (onebyfour
     (list
      (- (* u2 v3) (* u3 v2))
      (- (* u3 v1) (* u1 v3))
      (- (* u1 v2) (* u2 v1))
      0))))

(defun subtract! (thematrix thedelta)
  (let* ((dims (array-dimensions thematrix))
	 (rows (first dims))
	 (columns (second dims)))
    (dotimes (r rows)
      (dotimes (c columns)
	(setf (aref thematrix r c)
	      (-
	       (aref thematrix r c)
	       (aref thedelta r c)))))))

(defun subtract (thematrix thedelta)
  (let* ((dims (array-dimensions thematrix))
	 (rows (first dims))
	 (columns (second dims))
	 (newmatrix (make-array (list rows columns))))
    (dotimes (r rows)
      (dotimes (c columns)
	(setf (aref newmatrix r c)
	      (-
	       (aref thematrix r c)
	       (aref thedelta r c)))))
    newmatrix))

(defun add! (thematrix thedelta)
  (let* ((dims (array-dimensions thematrix))
	 (rows (first dims))
	 (columns (second dims)))
    (dotimes (r rows)
      (dotimes (c columns)
	(setf (aref thematrix r c)
	      (+
	       (aref thematrix r c)
	       (aref thedelta r c)))))))

(defun add (thematrix thedelta)
  (let* ((dims (array-dimensions thematrix))
	 (rows (first dims))
	 (columns (second dims))
	 (newmatrix (make-array (list rows columns))))
    (dotimes (r rows)
      (dotimes (c columns)
	(setf (aref newmatrix r c)
	      (+
	       (aref thematrix r c)
	       (aref thedelta r c)))))
    newmatrix))

(defun scale! (thematrix scale)
  (let* ((dims (array-dimensions thematrix))
	 (rows (first dims))
	 (columns (second dims)))
    (dotimes (r rows)
      (dotimes (c columns)
	(setf (aref thematrix r c)
	      (*
	       (aref thematrix r c)
	       scale)))))
  thematrix)

(defun scale (thematrix scale)
  (let* ((dims (array-dimensions thematrix))
	 (rows (first dims))
	 (columns (second dims))
	 (newmatrix (make-array (list rows columns))))
    (dotimes (r rows)
      (dotimes (c columns)
	(setf (aref newmatrix r c)
	      (*
	       (aref thematrix r c)
	       scale))))
    newmatrix))

(defun vec-hypot (thevec)
  (let ((num 0))
    (dotimes (n (array-total-size thevec))
      (incf num (expt (row-major-aref thevec n) 2)))
    (sqrt num)))

(defun normalize! (thevec)
  (let* ((tot (vec-hypot thevec)))
    (if (/= 0 tot)
	(dotimes (n (array-total-size thevec))
	  (setf (row-major-aref thevec n)
		(/ (row-major-aref thevec n) tot))))
    thevec))

(defun to-flat (thematrix)
  (let* ((len (array-total-size thematrix))
	 (dims (array-dimensions thematrix))
	 (rows (first dims))
	 (columns (second dims))
	 (tharray
	  (make-array len :element-type 'single-float)))
    (dotimes (i rows)
      (dotimes (j columns)
	(setf (aref tharray (+ j (* i columns))) (aref thematrix i j))))
    tharray))

(defun scaling-matrix (xscale yscale zscale)
  (fourbyfour 
   (list(list xscale 0 0 0)
	(list 0 yscale 0 0)
	(list 0 0 zscale 0)
	(list 0 0 0 1))))

(defun identity-matrix ()
  (fourbyfour
   (list(list 1 0 0 0)
	(list 0 1 0 0)
	(list 0 0 1 0)
	(list 0 0 0 1))))

(defun translation-matrix (xscale yscale zscale)
  (fourbyfour
   (list(list 1 0 0 xscale)
	(list 0 1 0 yscale)
	(list 0 0 1 zscale)
	(list 0 0 0      1))))

(defun rotation-matrix (x y z theta)
  (let* ((fuck (normalize! (onebyfour (list x y z 0))))
	 (xrot (row-major-aref fuck 0))
	 (yrot (row-major-aref fuck 1))
	 (zrot (row-major-aref fuck 2))
	 (si (sin theta))
	 (co (cos theta))
	 (oc (- 1 co)))
    (fourbyfour
     (list(list (+ co (* xrot xrot oc))
		(- (* xrot yrot oc) (* zrot si))
		(+ (* xrot zrot oc) (* yrot si)) 0)	   
	  (list (+ (* xrot yrot oc) (* zrot si))
		(+ co (* yrot yrot oc))
		(- (* zrot yrot oc) (* xrot si)) 0)	   
	  (list (- (* xrot zrot oc) (* yrot si))
		(+ (* yrot zrot oc) (* xrot si))
		(+ co (* zrot zrot oc)) 0)	   
	  (list 0 0 0 1)))))

(defun fucking-projection-matrix (near far left right top bottom)
  (fourbyfour
   (list
    (list
     (/ (+ near near) (- right left)) 0 (/ (+ right left) (- right left)) 0)
    (list
     0 (/ (+ near near) (- top bottom)) (/ (+ top bottom) (- top bottom)) 0)
    (list
     0 0 (- (/ (+ far near) (- far near))) (/ (* -2 far near) (- far near)))
    (list
     0 0 -1 0))))

(defun projection-matrix (fovy aspect near far)
  (fourbyfour
   (let ((cot (/ (cos (/ fovy 2)) (sin (/ fovy 2)))))
     (list(list (/ cot aspect) 0 0 0)
	  (list 0 cot 0 0)
	  (list 0 0
		(/ (+ far near) (- near far))
		(/ (* -2 far near) (- far near)))
	  (list 0 0 -1 0)))))

(defun hypot (args)
  (if args
      (+ (hypot (cdr args)) (expt (car args) 2))
      0))

(defun matrix-multiply (matrix1 matrix2)
 (mapcar
  (lambda (row)
   (apply #'mapcar
    (lambda (&rest column)
      (apply #'+ (mapcar #'* row column)))
    matrix2))
  matrix1))

(defun mmul! (A B)
  (let ((c (mmul A B)))
    (dotimes (n (first (array-dimensions a)))
      (dotimes (m (second (array-dimensions a)))
	(setf
	 (aref A n m)
	 (aref c n m)))))
  a)

(defun mmul (A B)
  (let* ((m (car (array-dimensions A)))
         (n (cadr (array-dimensions A)))
         (l (cadr (array-dimensions B)))
         (C (make-array `(,m ,l) :initial-element 0)))
    (loop for i from 0 to (- m 1) do
              (loop for k from 0 to (- l 1) do
                    (setf (aref C i k)
                          (loop for j from 0 to (- n 1)
                                sum (* (aref A i j)
                                       (aref B j k))))))
    C))

(defun relative-lookat (eye relative-target up)
  (let* ((camright
	  (mat:normalize!
	   (mat:cross up relative-target)))
	 (camup
	  (mat:cross relative-target camright)))
    (mat:get-lookat
     camright camup relative-target eye)))

(defun absolute-lookat (eye target up)
  (let* ((camdirection (mat:subtract eye target))
	 (camright
	  (mat:normalize!
	   (mat:cross up camdirection)))
	 (camup
	  (mat:cross camdirection camright)))
    (mat:get-lookat
     camright camup camdirection eye)))

(defun easy-lookat (eye pitch yaw)
  (relative-lookat
   eye 
   (mat:normalize!
    (vector
     (* (cos pitch) (cos yaw))
     (sin pitch)
     (* (cos pitch) (sin yaw))))
   #(0.0 1.0 0.0)))