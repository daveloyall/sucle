(defpackage :cl-sound-ffmpeg
  (:use :cl :cffi :fuktard))

(in-package :cl-sound-ffmpeg)

(progn
  (define-foreign-library libavutil
    (t (:default "libavutil")))
  (use-foreign-library libavutil)
  (define-foreign-library libavcodec
    (t (:default "libavcodec")))
  (use-foreign-library libavcodec)
  (define-foreign-library libavformat
    (t (:default "libavformat")))
  (use-foreign-library libavformat)
  (define-foreign-library libswresample
    (t (:default "libswresample")))
  (use-foreign-library libswresample))

(defparameter *music*
  (case 6
    (0 "/home/terminal256/src/symmetrical-umbrella/sandbox/res/resources/sound3/damage/hit3.ogg")
    (1 "/home/terminal256/src/symmetrical-umbrella/sandbox/res/resources/streaming/cat.ogg")
    (2 "/home/terminal256/src/symmetrical-umbrella/sandbox/res/resources/sound3/portal/portal.ogg")
    (3 "/home/imac/quicklisp/local-projects/symmetrical-umbrella/sandbox/res/resources/sound3/ambient/weather/rain4.ogg")
    (4 "/home/imac/Music/6PQv-Adele - Hello.mp3")
    (5 "/home/imac/Music/Louis The Child ft. K.Flay - It's Strange [Premiere] (FIFA 16 Soundtrack) -  128kbps.mp3")
    (6 "/home/imac/Music/Birdy_-_Keeping_Your_Head_Up_Official.mp3")))
(progn
  (defparameter dubs nil)
  (defparameter size nil)
  (defparameter ans nil)


  (defun test (&optional (music *music*))
    (reset)
    (setf (values dubs size ans)
	  (get-sound-buff :music music))
    )

  (defun reset ()
    (when (pointerp dubs)
      
      (foreign-free dubs)
      (setf dubs nil)))

  (defun alut-hello-world ()
    (alc:with-device (device)
      (alc:with-context (context device)
	(alc:make-context-current context)
	(al:with-source (source)
	  (al:with-buffer (buffer)
	    (al:buffer-data buffer :mono16 dubs (* 2 size) 44100)
	    (al:source source :buffer buffer)
	    (al:source-play source)
	    (read)))))))

(defcstruct |AVIOInterruptCB|
  (callback :pointer)
  (opaque :pointer))

(defcstruct |AVFormatContext|
  (av_class :pointer)
  (iformat :pointer)
  (oformat :pointer)
  (priv_data :pointer)
  (pb :pointer)
  (ctx_flags :int)
  (nb_streams :uint)
  (streams :pointer)
  (filename :char :count 1024)
  (start_time :int64)
  (duration :int64)
  (bit_rate :int64)
  (packet_size :uint)
  (max_delay :int)
  (flags :int)
  (probesize :int64)
  (max_analyze_duration :int64)
  (key :pointer)
  (keylen :int)
  (nb_programs :uint)
  (programs :pointer)
  (video_codec_id :int)
  (audio_codec_id :int)
  (subtitle_codec_id :int)
  (max_index_size :uint)
  (max_picture_buffer :uint)
  (nb_chapters :uint)
  (chapters :pointer)
  (metadata :pointer)
  (start_time_realtime :int64)
  (fps_probe_size :int)
  (error_recognition :int)
  (interrupt_callback (:struct |AVIOInterruptCB|))
  (debug :int)
  (max_interleave_delta :int64)
  (strict_std_compliance :int)
  (event_flags :int)
  (max_ts_probe :int)
  (avoid_negative_ts :int)
  (ts_id :int)
  (audio_preload :int)
  (max_chunk_duration :int)
  (max_chunk_size :int)
  (use_wallclock_as_timestamps :int)
  (avio_flags :int)
  (duration_estimation_method :int)
  (skip_initial_bytes :int64)
  (correct_ts_overflow :uint)
  (seek2any :int)
  (flush_packets :int)
  (probe_score :int)
  (format_probesize :int)
  (codec_whitelist :pointer)
  (format_whitelist :pointer)
  (internal :pointer)
  (io_repositioned :int)
  (video_codec :pointer)
  (audio_codec :pointer)
  (subtitle_codec :pointer)
  (data_codec :pointer)
  (metadata_header_padding :int)
  (opaque :pointer)
  (control_message_cb :pointer);;;what??!?
  (output_ts_offset :int64)
  (dump_separator :pointer)
  (data_codec_id :int)
  (protocol_whitelist :pointer)
  (io_open :pointer)
  (io_close :pointer))

(defcstruct |AVPacket|
  (buf :pointer)
  (pts :int64)
  (dts :int64)
  (data :pointer)
  (size :int)
  (stream_index :int)
  (flags :int)
  (side_data :pointer)
  (side_data_elems :int)
  (duration :int)
  (destruct  :pointer)
  (priv :pointer)
  (pos :int64)
  (convergence_duration :int64))

(defcstruct |AVRational|
  (num :int)
  (den :int))

(defcstruct |AVFrame|
  (data :pointer :count 8)
  (linesize :int :count 8)
  (extended_data :pointer)
  (width :int)
  (height :int)
  (nb_samples :int)
  (format :int)
  (key_frame :int)
  (pict_type :int)
  (sample_aspect_ratio (:struct |AVRational|))
  (pts :int64)
  (pkt_pts :int64)
  (pkt_dts :int64)
  (coded_picture_number :int)
  (display_picture_number :int)
  (quality :int)
  (opaque :pointer)
  (error :uint64 :count 8)
  (repeat_pict :int)
  (interlaced_frame :int)
  (top_field_first :int)
  (palette_has_changed :int)
  (reordered_opaque :int64)
  (sample_rate :int)
  (channel_layout :uint64)
  (buf :pointer :count 8)
  (extended_buf :pointer)
  (nb_extended_buf :int)
  (side_data :pointer)
  (nb_side_data :int)
  (flags :int)
  (color_range :int)
  (color_primaries :int)
  (color_trc :int)
  (colorspace :int)
  (chroma_location :int)
  (best_effort_timestamp :int64)
  (pkt_pos :int64)
  (pkt_duration :int64)
  (metadata :pointer)
  (decode_error_flags :int)
  (channels :int)
  (pkt_size :int)
  (qscale_table :pointer)
  (qstride :int)
  (qscale_type :int)
  (qp_table_buf :pointer))

(defcstruct |AudioData|
  (class :pointer)
  (data  :pointer :count 32)
  (buffer :pointer)
  (buffer_size :uint)
  (allocated_samples :int)
  (nb_samples :int)
  (sample_fmt :int)
  (channels :int)
  (allocated_channels :int)
  (is_planar :int)
  (planes :int)
  (sample_size :int)
  (stride :int)
  (read_only :int)
  (allow_realloc :int)
  (ptr_align :int)
  (samples_align :int)
  (name :pointer)
  (ch :pointer :count 32)
  (ch_count :int)
  (bps :int)
  (count :int)
  (planar :int)
  (fmt :int))

(defcstruct |DitherDSPContext|
  (quantize :pointer)
  (ptr_align :int)
  (samples-align :int)
  (dither_int_to_float :pointer))

(defcstruct |DitherContext|
  (ddsp (:struct |DitherDSPContext|))
  (method :int)
  (apply_map :int)
  (ch_map_info :pointer)
  (mute_dither_threshold :int)
  (mute_reset_threshold :int)
  (ns_coef_b :pointer)
  (ns_coef_a :pointer)
  (channels :int)
  (state :pointer)
  (flt_data :pointer)
  (s16_data :pointer)
  (ac_in :pointer)
  (ac_out :pointer)
  (quantize :pointer)
  (samples_align :int)
  (method :int)
  (noise_pos :int)
  (scale :float)
  (noise_scale :float)
  (ns_taps :int)
  (ns_scale :float)
  (ns_scale_1 :float)
  (ns_pos :int)
  (ns_coeffs :float :count 20)
  (ns_errors :float :count 1280)
  (noise (:struct |AudioData|))
  (temp (:struct |AudioData|))
  (output_sample_bits :int))

(defcstruct |SwrContext|
  (av_class :pointer)
  (log_level_offset :int)
  (log_ctx :pointer)
  (in_sample_fmt :int)
  (int_sample_fmt :int)
  (out_sample_fmt :int)
  (in_ch_layout :int64)
  (out_ch_layout :int64)
  (in_sample_rate :int)
  (out_sample_rate :int)
  (flags :int)
  (slev :float)
  (clev :float)
  (lfe_mix_level :float)
  (rematrix_volume :float)
  (rematrix_maxval :float)
  (matrix_encoding :int)
  (channel_map :pointer)
  (used_ch_count :int)
  (engine :int)
  (dither (:struct |DitherContext|))
  (filter_size :int)
  (phase_shift :int)
  (linear_interp :int)
  (cutoff :double)
  (filter_type :int)
  (kaiser_beta :int)
  (precision :double)
  (cheby :int)
  (min_compensation :float)
  (min_hard_compensation :float)
  (soft_compensation_duration :float)
  (max_soft_compensation :float)
  (async :float)
  (firstpts_in_samples :int64)
  (resample_first :int)
  (rematrix :int)
  (rematrix_custom :int)
  (in (:struct |AudioData|))
  (postin (:struct |AudioData|))
  (midbuf (:struct |AudioData|))
  (preout (:struct |AudioData|))
  (out (:struct |AudioData|))
  (in_buffer (:struct |AudioData|))
  (silence (:struct |AudioData|))
  (drop_temp (:struct |AudioData|))
  (in_buffer_index :int)
  (in_buffer_count :int)
  (resample_in_constraint :int)
  (flushed :int)
  (outpts :int64)
  (firstpts :int64)
  (drop_output :int)
  (in_convert :pointer)
  (out_convert :pointer)
  (full_convert :pointer)
  (resample :pointer)
  (resampler :pointer)
  (matrix :float :count 1024)
  (native_matrix :pointer)
  (native_one :pointer)
  (native_simd_one :pointer)
  (native_simd_matrix :pointer)
  (matrix32 :int32 :count 1024)
  (matrix_ch :uint8 :count 1056)
  (mix_1_1_f :pointer)
  (mix_1_1_simd :pointer)
  (mix_2_1_f :pointer)
  (mix_2_1_simd :pointer)
  (mix_any_f :pointer))

(defcenum |AVMediaType|
  (:unknown -1)
  :video
  :audio
  :data
  :subtitle
  :attachment
  :nb)

(defcenum |AVSampleFormat|
  (:none -1)
  :u8
  :s16
  :s32
  :flt
  :fbl

  :u8p
  :s16p
  :s32p
  :fltp
  :dblp
  :s64
  :s64p

  :nb)

(defcstruct |AVCodecContext|
  (av_class :pointer)
  (log_level_offset :int)
  (codec_type |AVMediaType|)
  (codec :pointer)
  (codec_name :char :count 32)
  (codec_id :int)
  (codec_tag :uint)
  (stream_codec_tag :uint)
  (priv_data :pointer)
  (internal :pointer)
  (opaque :pointer)
  (bit_rate :int64)
  (bit_rate_tolerance :int)
  (global_quality :int)
  (compression_level :int)
  (flags :int)
  (flags2 :int)
  (extradata :pointer)
  (extradata_size :int)
  (time_base (:struct |AVRational|))
  (ticks_per_frame :int)
  (delay :int)
  (width :int)
  (height :int)
  (coded_width :int)
  (coded_height :int)
  (gop_size :int)
  (pix_fmt :int)
  (me_method :int)
  (draw_horiz_band :pointer)
  (get_format :pointer)
  (max_b_frames :int)
  (b_quant_factor :float)
  (rc_strategy :int)
  (b_frame_strategy :int)
  (b_quant_offset :float)
  (has_b_frames :int)
  (mpeg_quant :int)
  (i_quant_factor :float)
  (i_quant_offset :float)
  (lumi_masking :float)
  (temporal_cplx_masking :float)
  (spatial_cplx_masking :float)
  (p_masking :float)
  (dark_masking :float)
  (slice_count :int)
  (prediction_method :int)
  (slice_offset :pointer)
  (sample_aspect_ratio (:struct |AVRational|))
  (me_cmp :int)
  (me_sub_cmp :int)
  (mb_cmp :int)
  (ildct_cmp :int)
  (dia_size :int)
  (last_predictor_count :int)
  (pre_me :int)
  (me_pre_cmp :int)
  (pre_dia_size :int)
  (me_subpel_quality :int)
  (dtg_active_format :int)
  (me_range :int)
  (intra_quant_bias :int);;;;fine up here
  (inter_quant_bias :int);;;;fine here tooo
  (slice_flags :int)
  
  #+darwin(xvmc_acceleration :int)
  
  (mb_decision :int)
  (intra_matrix :pointer)
  (inter_matrix :pointer)
  (scenechange_threshold :int)
  (noise_reduction :int)
  (me_threshold :int)
  (mb_threshold :int)
  (intra_dc_precision :int)
  (skip_top :int)
  (skip_bottom :int)
  (border_masking :float)
  (mb_lmin :int)
  (mb_lmax :int)
  (me_penalty_compensation :int)
  (bidir_refine :int)
  (brd_scale :int)
  (keyint_min :int)
  (refs :int)
  (chromaoffset :int)
  (scenechange_factor :int)
  (mv0_threshold :int)
  (b_sensitivity :int)
  (color_primaries :int) ;;enum
  (color_trc :int);;enum
  (colorspace :int);;enum
  (color_range :int);;enum
  (chroma_sample_location :int);;enum
  (slices :int)
  (field_order :int);;enum
  (sample_rate :int);;;;;;;;;;;;;;; ::huh??
  (channels :int);;;;;;;;;;;;;;;;;;
  (sample_fmt |AVSampleFormat|);;;;;;;;;;;;;;;
  (frame_size :int)
  (frame_number :int) ;;;sample rate appearing here
  (block_align :int)
  (cutoff :int)
  (channel_layout :uint64);;;;;;;;;;;;;;
  (request_channel_layout :uint64)
  (audio_service_type :int)
  (request_sample_fmt :int)
  (get_buffer2 :pointer)
  (refcounted_frames :int)
  (qcompress :float)
  (qblur :float)
  (qmin :int)
  (qmax :int)
  (max_qdiff :int)
  (rc_qsquish :float)
  (rc_qmod_amp :float)
  (rc_qmod_freq :int)
  (rc_buffer_size :int)
  (rc_override_count :int)
  (rc_override :pointer)
  (rc_eq :pointer)
  (rc_max_rate :int64)
  (rc_min_rate :int64)
  (rc_buffer_aggressivity :float)
  (rc_initial_cplx :float)
  (rc_max_available_vbv_use :float)
  (rc_min_vbv_overflow_use :float)
  (rc_initial_buffer_occupancy :int)
  (coder_type :int)
  (context_model :int)
  (lmin :int)
  (lmax :int)
  (frame_skip_threshold :int)
  (frame_skip_factor :int)
  (frame_skip_exp :int)
  (frame_skip_cmp :int)
  (trellis :int)
  (min_prediction_order :int)
  (max_prediction_order :int)
  (timecode_frame_start :int64)
  (rtp_callback :pointer)
  (rtp_payload_size :int)
  (mv_bits :int)
  (header_bits :int)
  (i_tex_bits :int)
  (p_tex_bits :int)
  (i_count :int)
  (p_count :int)
  (skip_count :int)
  (misc_bits :int)
  (frame_bits :int)
  (stats_out :pointer)
  (stats_in :pointer)
  (workaround_bugs :int)
  (strict_std_compliance :int)
  (error_concealment :int)
  (debug :int)
  (debug_mv :int)
  (err_recognition :int)
  (reordered_opaque :int64)
  (hwaccel :pointer)
  (hwaccel_context :pointer)
  (error :uint64 :count 8)
  (dct_algo :int)
  (idct_algo :int)
  (bits_per_coded_sample :int)
  (bits_per_raw_sample :int)
  (lowres :int)
  (coded_frame :pointer)
  (thread_count :int)
  (thread_type :int)
  (active_thread_type :int)
  (thread_safe_callbacks :int)
  (execute :pointer)
  (execute2 :pointer)
  (nsse_weight :int)
  (profile :int)
  (level :int)
  (skip_loop_filter :int)
  (skip_idct :int)
  (skip_frame :int)
  (subtitle_header :pointer)
  (subtitle_header_size :int)
  (error_rate :int)
  (vbv_delay :uint64)
  (side_data_only_packets :int)
  (initial_padding :int)
  (framerate (:struct |AVRational|))
  (sw_pix_fmt :int)
  (pkt_timebase (:struct |AVRational|))
  (codec_descriptor :pointer)
  (pts_correction_num_faulty_pts :int64)
  (pts_correction_num_faulty_dts :int64)
  (pts_correction_last_pts :int64)
  (pts_correction_last_dts :int64)
  (sub_charenc :pointer)
  (sub_charenc_mode :int)
  (skip_alpha :int)
  (seek_preroll :int)
  (chroma_intra_matrix :pointer)
  (dump_separator :pointer)
  (codec_whitelist :pointer)
  (properties :unsigned-int)
  (coded_side_data :pointer)
  (nb_coded_side_data :int)
  (hw_frames_ctx :pointer)
  (sub_text_format :int)
  (trailing_padding :int))

(defcstruct |AVStream-aux|
  (last_dts :int64)
  (duration_gcd :int64)
  (duration_count :int)
  (rfps_duration_sum :int64)
  (duration_error :double)
  (codec_info_duration :int64)
  (codec_info_duration_fields :int64)
  (found_decoder :int)
  (last_duration :int64)
  (fps_first_dts :int64)
  (fps_first_dts_idx :int)
  (fps_last_dts :int64)
  (fps_last_dts_idx :int))

(defcstruct |AVProbeData|
  (filename :pointer)
  (buf :pointer)
  (buf_size :int)
  (mime_type :pointer))

(defcstruct |AVStream|
  (index :int)
  (id :int)
  (codec :pointer)
  (priv_data :pointer)
  (time_base (:struct |AVRational|))
  (start_time :int64)
  (duration :int64)
  (nb_frames :int64)
  (disposition :int)
  (discard :int)
  (sample_aspect_ratio (:struct |AVRational|))
  (metadata :pointer)
  (avg_frame_rate (:struct |AVRational|))
  (attached_pic (:struct |AVPacket|))
  (side_data :pointer)
  (nb_side_data :int)
  (event_flags :int)
  (info (:struct |AVStream-aux|))
  (pts_wrap_bits :int)
  (first_dts :int64)
  (cur_dts :int64)
  (last_IP_pts :int64)
  (last_IP_duration :int)
  (probe_packets :int)
  (codec_info_nb_frames :int)
  (need_parsing :int)
  (parser :pointer)
  (last_in_packet_buffer :pointer)
  (probe_data (:struct |AVProbeData|))
  (pts_buffer :int64 :count 17)
  (index_entries :pointer)
  (nb_index_entries :int)
  (index_entries_allocated_size :uint)
  (r_frame_rate (:struct |AVRational|))
  (stream_identifier :int)
  (interleaver_chunk_size :int64)
  (interleaver_chunk_duration :int64)
  (request_probe :int)
  (skip_to_keyframe :int)
  (skip_samples :int)
  (start_skip_samples :int64)
  (first_discard_sample :int64)
  (last_discard_sample :int64)
  (nb_decoded_frames :int)
  (mux_ts_offset :int64)
  (pts_wrap_reference :int64)
  (pts_wrap_behavior :int)
  (update_initial_durations_done :int)
  (pts_reorder_error :int64 :count 17)
  (pts_reorder_error_count :uint8 :count 17)
  (last_dts_for_order_check :int64)
  (dts_ordered :uint8)
  (dts_misordered :uint8)
  (inject_global_side_data :int)
  (recommended_encoder_configuration :pointer)
  (display_aspect_ratio (:struct |AVRational|))
  (priv_pts :pointer)
  (internal :pointer))

(defcfun ("av_register_all" av-register-all)
    :void)
(defcfun ("avformat_alloc_context" avformat-alloc-context)
    (:pointer (:struct |AVFormatContext|)))
(defcfun ("avformat_open_input" avformat-open-input)
    :int
  (ps :pointer)
  (filename :pointer)
  (fmt :pointer)
  (options :pointer))
(defcfun ("avformat_find_stream_info" avformat-find-stream-info)
    :int
  (ic :pointer)
  (options :pointer))
(defcfun ("avcodec_open2" avcodec-open2)
    :int
  (avctx :pointer)
  (codec :pointer)
  (options :pointer))

(defcfun ("avcodec_find_decoder" avcodec-find-decoder)
    :pointer
  (id :int))

(defcfun ("av_opt_set_int" av-opt-set-int)
    :int
  (obj :pointer)
  (name :string)
  (val :int64)
  (search_flags :int))
(defcfun ("av_opt_set_sample_fmt" av-opt-set-sample-fmt)
    :int
  (obj :pointer)
  (name :string)
  (fmt :int)
  (search_flags :int))

(defcfun ("swr_init" swr-init)
    :int
  (s :pointer))
(defcfun ("swr_alloc" swr-alloc)
    :pointer)
(defcfun ("swr_is_initialized" swr-is-initialized)
    :int
  (s :pointer))
(defcfun ("av_init_packet" av-init-packet)
    :void
  (s :pointer))

(defcfun ("av_frame_alloc" av-frame-alloc)
    :pointer)
(defcfun ("av_read_frame" av-read-frame)
    :int
  (s :pointer)
  (pkt :pointer))
(defcfun ("avcodec_decode_audio4" avcodec-decode-audio4)
    :int
  (avctx :pointer)
  (frame :pointer)
  (got_picture_ptr :pointer)
  (avpkt :pointer))

(defcfun ("av_samples_alloc" av-samples-alloc)
    :int
  (audio_data :pointer)
  (linesize :pointer)
  (nb_channels :int)
  (nb_samples :int)
  (sample_fmt :int)
  (align :int))

(defcfun ("swr_convert" swr-convert)
    :int
  (s :pointer)
  (out :pointer)
  (out_count :int)
  (in :pointer)
  (in_count :int))

(defcfun ("realloc" realloc)
    :pointer
  (ptr :pointer)
  (size :uint))

(defcfun ("memcpy" memcpy)
    :void
  (str1 :pointer)
  (str2 :pointer)
  (n :uint))

(defcfun ("av_frame_free" av-frame-free)
    :void
  (frame :pointer))
(defcfun ("swr_free" swr-free)
    :void
  (s :pointer))
(defcfun ("avcodec_close" avcodec-close)
    :int
  (avctx :pointer))
(defcfun ("avformat_free_context" avformat-free-context)
    :void
  (s :pointer))

(defun get-sound-buff (&key (music *music*) (sample-rate 44100))
  (block bye
    (let ((adubs nil)
	  (aans nil)
	  (asize -3))
      (cffi:with-foreign-string (path music)
	;; initialize all muxers, demuxers and protocols for libavformat
	;; (does nothing if called twice during the course of one program execution)
	(av-register-all)
	(cffi:with-foreign-objects ((data-pointer :pointer)
				    (an-int :int)
				    (&format :pointer)
				    (&swr :pointer)
				    (&frame :pointer)
				    (&stream :pointer)
				    (&codec :pointer))

	  (setf (cffi:mem-ref &format :pointer)
		(avformat-alloc-context))
;;;	  (print 343)
	  (unless (zerop
		   (avformat-open-input &format
					path
					(cffi:null-pointer)
					(cffi:null-pointer)))
	    (print "could not open file")
	    (return-from bye -1))
	  (when (> 0 (avformat-find-stream-info (cffi:mem-ref &format :pointer)
						(cffi:null-pointer)))
	    (print "could not retrive stream info from file")
	    (return-from bye -1))
	  (let ((stream-index (find-first-audio-stream2 (cffi:mem-ref &format :pointer))))
	    (when (= -1 stream-index)
	      (print "could not retrieve audio stream from file")
	      (return-from bye -1))
	    (let* ((stream-array (cffi:foreign-slot-value (cffi:mem-ref &format :pointer)
							  (quote (:struct |AVFormatContext|))
							  (quote streams)))
		   (the-stream (mem-aref stream-array
					 :pointer
					 stream-index)))
	      (setf (cffi:mem-ref &stream :pointer)
		    the-stream)))
	  (progn
	    ;;;find and open codec
	    (setf (cffi:mem-ref &codec :pointer)
		  (foreign-slot-value (cffi:mem-ref &stream :pointer)
				      (quote (:struct |AVStream|))
				      (quote codec)))
	    (when (> 0 (avcodec-open2 (cffi:mem-ref &codec :pointer)
				      (avcodec-find-decoder
				       (cffi:foreign-slot-value
					(cffi:mem-ref &codec :pointer)
					(quote (:struct |AVCodecContext|))
					(quote codec_id)))
				      (cffi:null-pointer)))
	      (print "failed to open decoder for stream number stream-index for file path")
	      (return-from bye -1)))
	  (progn
	    ;;prepare resampler
	    (setf (mem-ref &swr :pointer) (swr-alloc))
	    (prepare-resampler2 (cffi:mem-ref &swr :pointer)
				(cffi:mem-ref &codec :pointer)
				sample-rate)
	    (when (zerop (swr-is-initialized (cffi:mem-ref &swr :pointer)))
	      (print "resampler-not-properly initialized")
	      (return-from bye -1)))
	  (progn (setf (cffi:mem-ref &frame :pointer) (av-frame-alloc))
		 (when (cffi:null-pointer-p (cffi:mem-ref &frame :pointer))
		   (print "error allocating the frame")
		   (return-from bye -1)))
	  (cffi:with-foreign-object (packet (quote (:struct |AVPacket|)))
	    ;;prepare to read data
	    (av-init-packet packet)

	    (setf aans
		  (iterate-through-frames2 
		   (cffi:mem-ref &format :pointer)
		   packet
		   (cffi:mem-ref &codec :pointer)
		   (cffi:mem-ref &frame :pointer)
		   (cffi:mem-ref &swr :pointer)
		   data-pointer
		   an-int)))
	  (progn ;;clean up
	    (av-frame-free &frame)
	    (swr-free &swr)
	    (avcodec-close (cffi:mem-ref &codec :pointer))
	    (avformat-free-context (cffi:mem-ref &format :pointer)))
	  
	  (setf adubs (cffi:mem-ref data-pointer :pointer))
	  (setf asize (cffi:mem-ref an-int :int))))
      (values adubs asize aans))))

(defparameter av-ch-front-left 1)
(defparameter av-ch-front-right 2)
(defparameter av-ch-front-center 4)
(defparameter av-sample-fmt-16 1)


(defun print-struct (yo)
  (let ((odd -1)
	(acc nil)
	(temp nil))
    (dolist (x yo)
      (if (= -1 odd)
	  (push x temp)
	  (progn
	    (push x temp)
	    (push temp acc)
	    (setf temp nil)))
      (setf odd (* -1 odd)))
    (dolist (x acc)
      (princ x)
      (terpri))))

(defun prepare-resampler2 (swr codec user-sample-rate)
;;;  (print-struct (cffi:convert-from-foreign codec (quote (:struct |AVCodecContext|))))
  (cffi:with-foreign-slots ((channels
			     channel_layout
			     sample_rate
			     sample_fmt) codec (:struct |AVCodecContext|))
    (av-opt-set-int swr "in_channel_count" channels 0)
    (av-opt-set-int swr "out_channel_count" 1 0)
    (av-opt-set-int swr "in_channel_layout" channel_layout 0)
    (av-opt-set-int swr "out_channel_layout" av-ch-front-center 0)
    (av-opt-set-int swr "in_sample_rate" sample_rate 0)
    (av-opt-set-int swr "out_sample_rate" user-sample-rate 0)
    (av-opt-set-sample-fmt swr "in_sample_fmt" (cffi:foreign-enum-value
						(quote |AVSampleFormat|)
						sample_fmt) 0)
    (av-opt-set-sample-fmt swr "out_sample_fmt" (cffi:foreign-enum-value
						(quote |AVSampleFormat|)
						:s16)
			   0)
    )
  (swr-init swr))
(defparameter avmedia-type-audio 1)

(defun find-first-audio-stream2 (format)
  (let ((stream-index -1)
	(count (cffi:foreign-slot-value format
					(quote (:struct |AVFormatContext|))
					(quote nb_streams))))
    (block out
      (dotimes (index count)
	(let* ((streams (cffi:foreign-slot-value format
					(quote (:struct |AVFormatContext|))
					(quote streams)))
	       (stream (cffi:mem-aref
			streams
			:pointer))
	       (codec (cffi:foreign-slot-value stream
					(quote (:struct |AVStream|))
					(quote codec)))
	       (codec_type (cffi:foreign-slot-value codec
					(quote (:struct |AVCodecContext|))
					(quote codec_type))))
	  (when (eq :audio codec_type)
	    (setf stream-index index)
	    (return-from out)))))
    stream-index))

(defun iterate-through-frames2 (format packet codec frame swr data size)
  (setf (cffi:mem-ref data :pointer) (cffi:null-pointer))
  (setf (cffi:mem-ref size :int) 0)
  (loop
     (progn
       (unless (>= (av-read-frame format packet) 0)
	 (return))
       (cffi:with-foreign-objects ((gotframe :int))
	 (when (< (avcodec-decode-audio4 codec frame gotframe packet) 0)
	   (return))
	 (when (zerop (mem-ref gotframe :int))
	   (continue))
	 (cffi:with-foreign-object (&buffer :pointer)
	   (av-samples-alloc
	    &buffer
	    (cffi:null-pointer)
	    1
	    (cffi:foreign-slot-value frame
				     (quote (:struct |AVFrame|))
				     (quote nb_samples))
	    av-sample-fmt-16
	    0)
	   (let ((frame-count
		  (swr-convert swr
			       &buffer
			       (cffi:foreign-slot-value
				frame
				(quote (:struct |AVFrame|))
				(quote nb_samples))
			       (cffi:foreign-slot-value
				frame
				(quote (:struct |AVFrame|))
				(quote data))
			       (cffi:foreign-slot-value
				frame
				(quote (:struct |AVFrame|))
				(quote nb_samples)))))
	     (setf (cffi:mem-ref data :pointer)
		   (realloc (cffi:mem-ref data :pointer)
			    (* (cffi:foreign-type-size :int16)
			       (+ (cffi:mem-ref size :int)
				  (cffi:foreign-slot-value
				   frame
				   (quote (:struct |AVFrame|))
				   (quote nb_samples))))))
	     (memcpy (cffi:inc-pointer (mem-ref data :pointer) (* (foreign-type-size :int16)
								  (mem-ref size :int)))
		     (mem-ref &buffer :pointer)
		     (* frame-count (foreign-type-size :int16)))
	     (setf (mem-ref size :int)
		   (+ (mem-ref size :int)
		      frame-count))))))))

"  191 enum AVMediaType {
  192     AVMEDIA_TYPE_UNKNOWN = -1,  ///< Usually treated as AVMEDIA_TYPE_DATA
  193     AVMEDIA_TYPE_VIDEO,
  194     AVMEDIA_TYPE_AUDIO,
  195     AVMEDIA_TYPE_DATA,          ///< Opaque data information usually continuous
  196     AVMEDIA_TYPE_SUBTITLE,
  197     AVMEDIA_TYPE_ATTACHMENT,    ///< Opaque data information usually sparse
  198     AVMEDIA_TYPE_NB
  199 };"

"   59 enum AVSampleFormat {
   60     AV_SAMPLE_FMT_NONE = -1,
   61     AV_SAMPLE_FMT_U8,          ///< unsigned 8 bits
   62     AV_SAMPLE_FMT_S16,         ///< signed 16 bits
   63     AV_SAMPLE_FMT_S32,         ///< signed 32 bits
   64     AV_SAMPLE_FMT_FLT,         ///< float
   65     AV_SAMPLE_FMT_DBL,         ///< double
   66 
   67     AV_SAMPLE_FMT_U8P,         ///< unsigned 8 bits, planar
   68     AV_SAMPLE_FMT_S16P,        ///< signed 16 bits, planar
   69     AV_SAMPLE_FMT_S32P,        ///< signed 32 bits, planar
   70     AV_SAMPLE_FMT_FLTP,        ///< float, planar
   71     AV_SAMPLE_FMT_DBLP,        ///< double, planar
   72 
   73     AV_SAMPLE_FMT_NB           ///< Number of sample formats. DO NOT USE if linking dynamically
   74 };"

"   49 #define AV_CH_FRONT_LEFT             0x00000001
   50 #define AV_CH_FRONT_RIGHT            0x00000002
   51 #define AV_CH_FRONT_CENTER           0x00000004
   52 #define AV_CH_LOW_FREQUENCY          0x00000008
   53 #define AV_CH_BACK_LEFT              0x00000010
   54 #define AV_CH_BACK_RIGHT             0x00000020
   55 #define AV_CH_FRONT_LEFT_OF_CENTER   0x00000040
   56 #define AV_CH_FRONT_RIGHT_OF_CENTER  0x00000080
   57 #define AV_CH_BACK_CENTER            0x00000100
   58 #define AV_CH_SIDE_LEFT              0x00000200
   59 #define AV_CH_SIDE_RIGHT             0x00000400
   60 #define AV_CH_TOP_CENTER             0x00000800
   61 #define AV_CH_TOP_FRONT_LEFT         0x00001000
   62 #define AV_CH_TOP_FRONT_CENTER       0x00002000
   63 #define AV_CH_TOP_FRONT_RIGHT        0x00004000
   64 #define AV_CH_TOP_BACK_LEFT          0x00008000
   65 #define AV_CH_TOP_BACK_CENTER        0x00010000
   66 #define AV_CH_TOP_BACK_RIGHT         0x00020000
   67 #define AV_CH_STEREO_LEFT            0x20000000  ///< Stereo downmix.
   68 #define AV_CH_STEREO_RIGHT           0x40000000  ///< See AV_CH_STEREO_LEFT.
   69 #define AV_CH_WIDE_LEFT              0x0000000080000000ULL
   70 #define AV_CH_WIDE_RIGHT             0x0000000100000000ULL
   71 #define AV_CH_SURROUND_DIRECT_LEFT   0x0000000200000000ULL
   72 #define AV_CH_SURROUND_DIRECT_RIGHT  0x0000000400000000ULL
   73 #define AV_CH_LOW_FREQUENCY_2        0x0000000800000000ULL
   74 
   75 /** Channel mask value used for AVCodecContext.request_channel_layout
   76     to indicate that the user requests the channel order of the decoder output
   77     to be the native codec channel order. */
   78 #define AV_CH_LAYOUT_NATIVE          0x8000000000000000ULL
   79 
   80 /**
   81  * @}
   82  * @defgroup channel_mask_c Audio channel convenience macros
   83  * @{
   84  * */
   85 #define AV_CH_LAYOUT_MONO              (AV_CH_FRONT_CENTER)
   86 #define AV_CH_LAYOUT_STEREO            (AV_CH_FRONT_LEFT|AV_CH_FRONT_RIGHT)
   87 #define AV_CH_LAYOUT_2POINT1           (AV_CH_LAYOUT_STEREO|AV_CH_LOW_FREQUENCY)
   88 #define AV_CH_LAYOUT_2_1               (AV_CH_LAYOUT_STEREO|AV_CH_BACK_CENTER)
   89 #define AV_CH_LAYOUT_SURROUND          (AV_CH_LAYOUT_STEREO|AV_CH_FRONT_CENTER)
   90 #define AV_CH_LAYOUT_3POINT1           (AV_CH_LAYOUT_SURROUND|AV_CH_LOW_FREQUENCY)
   91 #define AV_CH_LAYOUT_4POINT0           (AV_CH_LAYOUT_SURROUND|AV_CH_BACK_CENTER)
   92 #define AV_CH_LAYOUT_4POINT1           (AV_CH_LAYOUT_4POINT0|AV_CH_LOW_FREQUENCY)
   93 #define AV_CH_LAYOUT_2_2               (AV_CH_LAYOUT_STEREO|AV_CH_SIDE_LEFT|AV_CH_SIDE_RIGHT)
   94 #define AV_CH_LAYOUT_QUAD              (AV_CH_LAYOUT_STEREO|AV_CH_BACK_LEFT|AV_CH_BACK_RIGHT)
   95 #define AV_CH_LAYOUT_5POINT0           (AV_CH_LAYOUT_SURROUND|AV_CH_SIDE_LEFT|AV_CH_SIDE_RIGHT)
   96 #define AV_CH_LAYOUT_5POINT1           (AV_CH_LAYOUT_5POINT0|AV_CH_LOW_FREQUENCY)
   97 #define AV_CH_LAYOUT_5POINT0_BACK      (AV_CH_LAYOUT_SURROUND|AV_CH_BACK_LEFT|AV_CH_BACK_RIGHT)
   98 #define AV_CH_LAYOUT_5POINT1_BACK      (AV_CH_LAYOUT_5POINT0_BACK|AV_CH_LOW_FREQUENCY)
   99 #define AV_CH_LAYOUT_6POINT0           (AV_CH_LAYOUT_5POINT0|AV_CH_BACK_CENTER)
  100 #define AV_CH_LAYOUT_6POINT0_FRONT     (AV_CH_LAYOUT_2_2|AV_CH_FRONT_LEFT_OF_CENTER|AV_CH_FRONT_RIGHT_OF_CENTER)
  101 #define AV_CH_LAYOUT_HEXAGONAL         (AV_CH_LAYOUT_5POINT0_BACK|AV_CH_BACK_CENTER)
  102 #define AV_CH_LAYOUT_6POINT1           (AV_CH_LAYOUT_5POINT1|AV_CH_BACK_CENTER)
  103 #define AV_CH_LAYOUT_6POINT1_BACK      (AV_CH_LAYOUT_5POINT1_BACK|AV_CH_BACK_CENTER)
  104 #define AV_CH_LAYOUT_6POINT1_FRONT     (AV_CH_LAYOUT_6POINT0_FRONT|AV_CH_LOW_FREQUENCY)
  105 #define AV_CH_LAYOUT_7POINT0           (AV_CH_LAYOUT_5POINT0|AV_CH_BACK_LEFT|AV_CH_BACK_RIGHT)
  106 #define AV_CH_LAYOUT_7POINT0_FRONT     (AV_CH_LAYOUT_5POINT0|AV_CH_FRONT_LEFT_OF_CENTER|AV_CH_FRONT_RIGHT_OF_CENTER)
  107 #define AV_CH_LAYOUT_7POINT1           (AV_CH_LAYOUT_5POINT1|AV_CH_BACK_LEFT|AV_CH_BACK_RIGHT)
  108 #define AV_CH_LAYOUT_7POINT1_WIDE      (AV_CH_LAYOUT_5POINT1|AV_CH_FRONT_LEFT_OF_CENTER|AV_CH_FRONT_RIGHT_OF_CENTER)
  109 #define AV_CH_LAYOUT_7POINT1_WIDE_BACK (AV_CH_LAYOUT_5POINT1_BACK|AV_CH_FRONT_LEFT_OF_CENTER|AV_CH_FRONT_RIGHT_OF_CENTER)
  110 #define AV_CH_LAYOUT_OCTAGONAL         (AV_CH_LAYOUT_5POINT0|AV_CH_BACK_LEFT|AV_CH_BACK_CENTER|AV_CH_BACK_RIGHT)
  111 #define AV_CH_LAYOUT_STEREO_DOWNMIX    (AV_CH_STEREO_LEFT|AV_CH_STEREO_RIGHT)"