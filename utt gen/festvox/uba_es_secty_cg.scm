;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                     ;;;
;;;                     Carnegie Mellon University                      ;;;
;;;                      Copyright (c) 1998-2011                        ;;;
;;;                        All Rights Reserved.                         ;;;
;;;                                                                     ;;;
;;; Permission is hereby granted, free of charge, to use and distribute ;;;
;;; this software and its documentation without restriction, including  ;;;
;;; without limitation the rights to use, copy, modify, merge, publish, ;;;
;;; distribute, sublicense, and/or sell copies of this work, and to     ;;;
;;; permit persons to whom this work is furnished to do so, subject to  ;;;
;;; the following conditions:                                           ;;;
;;;  1. The code must retain the above copyright notice, this list of   ;;;
;;;     conditions and the following disclaimer.                        ;;;
;;;  2. Any modifications must be clearly marked as such.               ;;;
;;;  3. Original authors' names are not deleted.                        ;;;
;;;  4. The authors' names are not used to endorse or promote products  ;;;
;;;     derived from this software without specific prior written       ;;;
;;;     permission.                                                     ;;;
;;;                                                                     ;;;
;;; CARNEGIE MELLON UNIVERSITY AND THE CONTRIBUTORS TO THIS WORK        ;;;
;;; DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING     ;;;
;;; ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT  ;;;
;;; SHALL CARNEGIE MELLON UNIVERSITY NOR THE CONTRIBUTORS BE LIABLE     ;;;
;;; FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES   ;;;
;;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN  ;;;
;;; AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,         ;;;
;;; ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF      ;;;
;;; THIS SOFTWARE.                                                      ;;;
;;;                                                                     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                      ;;
;;;  A generic voice definition file for a clustergen synthesizer        ;;
;;;  Customized for: uba_es_secty                                       ;;
;;;                                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Try to find the directory where the voice is, this may be from
;;; .../festival/lib/voices/ or from the current directory
(if (assoc 'uba_es_secty_cg voice-locations)
    (defvar uba_es_secty::dir 
      (cdr (assoc 'uba_es_secty_cg voice-locations)))
    (defvar uba_es_secty::dir (string-append (pwd) "/")))

;;; Did we succeed in finding it
(if (not (probe_file (path-append uba_es_secty::dir "festvox/")))
    (begin
     (format stderr "uba_es_secty::clustergen: Can't find voice scm files they are not in\n")
     (format stderr "   %s\n" (path-append  uba_es_secty::dir "festvox/"))
     (format stderr "   Either the voice isn't linked in Festival library\n")
     (format stderr "   or you are starting festival in the wrong directory\n")
     (error)))

;;;  Add the directory contains general voice stuff to load-path
(set! load-path (cons (path-append uba_es_secty::dir "festvox/") 
		      load-path))

(require 'clustergen)  ;; runtime scheme support

;;; Voice specific parameter are defined in each of the following
;;; files
(require 'uba_es_secty_phoneset_mex)
(require 'uba_es_secty_tokenizer)
(require 'uba_es_secty_tagger)
(require 'uba_es_secty_lexicon_mex_2)
(require 'uba_es_secty_phrasing)
(require 'uba_es_secty_intonation)
(require 'uba_es_secty_durdata_cg) 
(require 'uba_es_secty_f0model)
(require 'uba_es_secty_other)

(require 'uba_es_secty_statenames)
(voice_el_diphone)
;; ... and others as required

;;;
;;;  Code specific to the clustergen waveform synthesis method
;;;

;(set! cluster_synth_method 
;  (if (boundp 'mlsa_resynthesis)
;      cg_wave_synth
;      cg_wave_synth_external ))

;;; Flag to save multiple loading of db
(defvar uba_es_secty::cg_loaded nil)
;;; When set to non-nil clunits voices *always* use their closest voice
;;; this is used when generating the prompts
(defvar uba_es_secty::clunits_prompting_stage nil)

;;; You may wish to change this (only used in building the voice)
(set! uba_es_secty::closest_voice 'voice_kal_diphone_es)

(set! es_phone_maps
      '(
;        (M_t t)
;        (M_dH d)
;        ...
        ))

(define (voice_kal_diphone_es_phone_maps utt)
  (mapcar
   (lambda (s) 
     (let ((m (assoc_string (item.name s) es_phone_maps)))
       (if m
           (item.set_feat s "us_diphone" (cadr m))
           (item.set_feat s "us_diphone"))))
   (utt.relation.items utt 'Segment))
  utt)

(define (voice_kal_diphone_es)
  (voice_kal_diphone)
  (set! UniSyn_module_hooks (list voice_kal_diphone_es_phone_maps ))

  'kal_diphone_es
)

;;;  These are the parameters which are needed at run time
;;;  build time parameters are added to this list from build_clunits.scm
(set! uba_es_secty_cg::dt_params
      (list
       (list 'db_dir 
             (if (string-matches uba_es_secty::dir ".*/")
                 uba_es_secty::dir
                 (string-append uba_es_secty::dir "/")))
       '(name uba_es_secty)
       '(index_name uba_es_secty)
       '(trees_dir "festival/trees/")
       '(clunit_name_feat lisp_uba_es_secty::cg_name)
))

;; So as to fit nicely with existing clunit voices we check need to 
;; prepend these params if we already have some set.
(if (boundp 'uba_es_secty::dt_params)
    (set! uba_es_secty::dt_params
          (append 
           uba_es_secty_cg::dt_params
           uba_es_secty::dt_params))
    (set! uba_es_secty::dt_params uba_es_secty_cg::dt_params))

(define (uba_es_secty::nextvoicing i)
  (let ((nname (item.feat i "n.name")))
    (cond
;     ((string-equal nname "pau")
;      "PAU")
     ((string-equal "+" (item.feat i "n.ph_vc"))
      "V")
     ((string-equal (item.feat i "n.ph_cvox") "+")
      "CVox")
     (t
      "UV"))))

(define (uba_es_secty::cg_name i)
  (let ((x nil))
  (if (assoc 'cg::trajectory clustergen_mcep_trees)
      (set! x i)
      (set! x (item.relation.parent i 'mcep_link)))

  (let ((ph_clunit_name 
         (uba_es_secty::clunit_name_real
          (item.relation
           (item.relation.parent x 'segstate)
           'Segment))))
    (cond
     ((string-equal ph_clunit_name "ignore")
      "ignore")
     (t
      (item.name i)))))
)

(define (uba_es_secty::clunit_name_real i)
  "(uba_es_secty::clunit_name i)
Defines the unit name for unit selection for es.  The can be modified
changes the basic classification of unit for the clustering.  By default
this we just use the phone name, but you may want to make this, phone
plus previous phone (or something else)."
  (let ((name (item.name i)))
    (cond
     ((and (not uba_es_secty::cg_loaded)
	   (or (string-equal "h#" name) 
	       (string-equal "1" (item.feat i "ignore"))
	       (and (string-equal "pau" name)
		    (or (string-equal "pau" (item.feat i "p.name"))
			(string-equal "h#" (item.feat i "p.name")))
		    (string-equal "pau" (item.feat i "n.name")))))
      "ignore")
     ;; Comment out this if you want a more interesting unit name
     ((null nil)
      name)

     ;; Comment out the above if you want to use these rules
     ((string-equal "+" (item.feat i "ph_vc"))
      (string-append
       name
       "_"
       (item.feat i "R:SylStructure.parent.stress")
       "_"
       (uba_es_secty::nextvoicing i)))
     ((string-equal name "pau")
      (string-append
       name
       "_"
       (uba_es_secty::nextvoicing i)))
     (t
      (string-append
       name
       "_"
;       (item.feat i "seg_onsetcoda")
;       "_"
       (uba_es_secty::nextvoicing i))))))

(define (uba_es_secty::rfs_load_models)
  (let ((c 1))
    (set! uba_es_secty:rfs_models nil)
    (if (probe_file (format nil "%s/rf_models/mlist" uba_es_secty::dir))
        (set! uba_es_secty:rfs_models
              (mapcar
               (lambda (c)
                 (list
                  (load (format nil "%s/rf_models/trees_%02d/uba_es_secty_mcep.tree" uba_es_secty::dir c) t)
                  (track.load (format nil "%s/rf_models/trees_%02d/uba_es_secty_mcep.params" uba_es_secty::dir c))))
               (load (format nil "%s/rf_models/mlist" uba_es_secty::dir) t)))
        ;; no mlist file so just load all of them
        (while (<= c cg:rfs)
               (set! uba_es_secty:rfs_models
                     (cons
                      (list
                       (load (format nil "%s/rf_models/trees_%02d/uba_es_secty_mcep.tree" uba_es_secty::dir c) t)
                       (track.load (format nil "%s/rf_models/trees_%02d/uba_es_secty_mcep.params" uba_es_secty::dir c)))
                      uba_es_secty:rfs_models))
               (set! c (+ 1 c))))
    uba_es_secty:rfs_models))

(define (uba_es_secty::rfs_load_dur_models)
  (let ((c 1) (dur_tree))
    (set! uba_es_secty:rfs_dur_models nil)
    (if (probe_file (format nil "%s/dur_rf_models/mlist" uba_es_secty::dir))
        (set! uba_es_secty:rfs_dur_models
         (mapcar
          (lambda (c)
            (load (format nil "%s/dur_rf_models/dur_%02d/uba_es_secty_durdata_cg.scm" uba_es_secty::dir c))
            uba_es_secty::zdur_tree)
          (load (format nil "%s/dur_rf_models/mlist" uba_es_secty::dir) t)))
        ;; no mlist file so just load all of them
        ;; Probably not viable for multiple voices at once
        (while (<= c cg:rfs_dur)
               (load (format nil "%s/dur_rf_models/dur_%02d/uba_es_secty_durdata_cg.scm" uba_es_secty::dir c))
               (set! uba_es_secty:rfs_dur_models
                     (cons
                      uba_es_secty::zdur_tree
                      uba_es_secty:rfs_dur_models))
               (set! c (+ 1 c))))
    uba_es_secty:rfs_dur_models))

(define (uba_es_secty::cg_dump_model_filenames ofile)
  "(cg_dump_model_files ofile)
Dump the names of the files that must be included in the distribution."
  (let ((ofd (fopen ofile "w")))
    (format ofd "festival/lib/voices/es/uba_es_secty_cg/festival/trees/uba_es_secty_f0.tree\n")
    (if cg:rfs
        (begin
          (mapcar
           (lambda (mn)
             (format ofd "festival/lib/voices/es/uba_es_secty_cg/rf_models/trees_%02d/uba_es_secty_mcep.tree\n" mn)
             (format ofd "festival/lib/voices/es/uba_es_secty_cg/rf_models/trees_%02d/uba_es_secty_mcep.params\n" mn))
           (load "rf_models/mlist" t))
          (format ofd "festival/lib/voices/es/uba_es_secty_cg/rf_models/mlist\n")
          ))
    ;; Always include these too
    (format ofd "festival/lib/voices/es/uba_es_secty_cg/festival/trees/uba_es_secty_mcep.tree\n")
    (format ofd "festival/lib/voices/es/uba_es_secty_cg/festival/trees/uba_es_secty_mcep.params\n")

    (if cg:rfs_dur
        (begin
          (mapcar
           (lambda (mn)
             (format ofd "festival/lib/voices/es/uba_es_secty_cg/dur_rf_models/dur_%02d/uba_es_secty_durdata_cg.scm\n" mn))
           (load "dur_rf_models/mlist" t))
          (format ofd "festival/lib/voices/es/uba_es_secty_cg/dur_rf_models/mlist\n")
          )
        (begin
          ;; basic dur build
          ;; will get the duration tree from festvox/
          t
          ))
    (fclose ofd))
)

(define (uba_es_secty::cg_load)
  "(uba_es_secty::cg_load)
Function that actual loads in the databases and selection trees.
SHould only be called once per session."
  (set! dt_params uba_es_secty::dt_params)
  (set! clustergen_params uba_es_secty::dt_params)
  (if cg:multimodel
      (begin
        ;; Multimodel: separately trained statics and deltas
        (set! uba_es_secty::static_param_vectors
              (track.load
               (string-append 
                uba_es_secty::dir "/"
                (get_param 'trees_dir dt_params "trees/")
                (get_param 'index_name dt_params "all")
                "_mcep_static.params")))
        (set! uba_es_secty::clustergen_static_mcep_trees
              (load (string-append 
                     uba_es_secty::dir "/"
                     (get_param 'trees_dir dt_params "trees/")
                     (get_param 'index_name dt_params "all")
                     "_mcep_static.tree") t))
        (set! uba_es_secty::delta_param_vectors
              (track.load
               (string-append 
                uba_es_secty::dir "/"
                (get_param 'trees_dir dt_params "trees/")
                (get_param 'index_name dt_params "all")
                "_mcep_delta.params")))
        (set! uba_es_secty::clustergen_delta_mcep_trees
              (load (string-append 
                     uba_es_secty::dir "/"
                     (get_param 'trees_dir dt_params "trees/")
                     (get_param 'index_name dt_params "all")
                     "_mcep_delta.tree") t))
        (set! uba_es_secty::str_param_vectors
              (track.load
               (string-append
                uba_es_secty::dir "/"
                (get_param 'trees_dir dt_params "trees/")
                (get_param 'index_name dt_params "all")
                "_str.params")))
        (set! uba_es_secty::clustergen_str_mcep_trees
              (load (string-append
                     uba_es_secty::dir "/"
                     (get_param 'trees_dir dt_params "trees/")
                     (get_param 'index_name dt_params "all")
                     "_str.tree") t))
        (if (null (assoc 'cg::trajectory uba_es_secty::clustergen_static_mcep_trees))
            (set! uba_es_secty::clustergen_f0_trees
                  (load (string-append 
                          uba_es_secty::dir "/"
                          (get_param 'trees_dir dt_params "trees/")
                          (get_param 'index_name dt_params "all")
                          "_f0.tree") t)))
        )
      (begin
        ;; Single joint model 
        (set! uba_es_secty::param_vectors
              (track.load
               (string-append 
                uba_es_secty::dir "/"
                (get_param 'trees_dir dt_params "trees/")
                (get_param 'index_name dt_params "all")
                "_mcep.params")))
        (set! uba_es_secty::clustergen_mcep_trees
              (load (string-append 
                      uba_es_secty::dir "/"
                      (get_param 'trees_dir dt_params "trees/")
                      (get_param 'index_name dt_params "all")
                      "_mcep.tree") t))
        (if (null (assoc 'cg::trajectory uba_es_secty::clustergen_mcep_trees))
            (set! uba_es_secty::clustergen_f0_trees
                  (load (string-append 
                         uba_es_secty::dir "/"
                         (get_param 'trees_dir dt_params "trees/")
                         (get_param 'index_name dt_params "all")
                         "_f0.tree") t)))))

  ;; Random forests
  (if (and cg:rfs (not (boundp 'uba_es_secty:rfs_models)) )
      (uba_es_secty::rfs_load_models))
  (if (and cg:rfs_dur (not (boundp 'uba_es_VOICE:rfs_dur_models)))
      (uba_es_secty::rfs_load_dur_models))

  (set! uba_es_secty::cg_loaded t)
)

(define (uba_es_secty::voice_reset)
  "(uba_es_secty::voice_reset)
Reset global variables back to previous voice."
  (uba_es_secty::reset_phoneset)
  (uba_es_secty::reset_tokenizer)
  (uba_es_secty::reset_tagger)
  (uba_es_secty::reset_lexicon)
  (uba_es_secty::reset_phrasing)
  (uba_es_secty::reset_intonation)
  (uba_es_secty::reset_f0model)
  (uba_es_secty::reset_other)

  t
)

;; This function is called to setup a voice.  It will typically
;; simply call functions that are defined in other files in this directory
;; Sometime these simply set up standard Festival modules othertimes
;; these will be specific to this voice.
;; Feel free to add to this list if your language requires it

(define (voice_uba_es_secty_cg)
  "(voice_uba_es_secty_cg)
Define voice for es."
  ;; *always* required
  (voice_reset)

  ;; We are going to force a load of the local clustergen.scm file 
  ;; If we were more careful we could do this properly with parameters
  ;; but I doubt we'd get it right.
  (load (path-append uba_es_secty::dir "festvox/clustergen.scm"))

  ;; Select appropriate phone set
  (uba_es_secty::select_phoneset)

  ;; Select appropriate tokenization
  (uba_es_secty::select_tokenizer)

  ;; For part of speech tagging
  (uba_es_secty::select_tagger)

  (uba_es_secty::select_lexicon)

  (uba_es_secty::select_phrasing)

  (uba_es_secty::select_intonation)

  ;; For CG voice there is no duration modeling at the seg level
  (Parameter.set 'Duration_Method 'Default)
  (set! duration_cart_tree_cg uba_es_secty::zdur_tree)
  (set! duration_ph_info_cg uba_es_secty::phone_durs)
  (Parameter.set 'Duration_Stretch 1.0)

  (uba_es_secty::select_f0model)

  ;; Waveform synthesis model: cluster_gen
  (set! phone_to_states uba_es_secty::phone_to_states)
  (if (not uba_es_secty::clunits_prompting_stage)
      (begin
	(if (not uba_es_secty::cg_loaded)
	    (uba_es_secty::cg_load))
        (if cg:multimodel
            (begin
              (set! clustergen_param_vectors uba_es_secty::static_param_vectors)
              (set! clustergen_mcep_trees uba_es_secty::clustergen_static_mcep_trees)
              (set! clustergen_delta_param_vectors uba_es_secty::delta_param_vectors)
              (set! clustergen_delta_mcep_trees uba_es_secty::clustergen_delta_mcep_trees)
              (set! clustergen_str_param_vectors uba_es_secty::str_param_vectors)
              (set! clustergen_str_mcep_trees uba_es_secty::clustergen_str_mcep_trees)

              )
            (begin
              (set! clustergen_param_vectors uba_es_secty::param_vectors)
              (set! clustergen_mcep_trees uba_es_secty::clustergen_mcep_trees)
              ))
        (if (boundp 'uba_es_secty::clustergen_f0_trees)
            (set! clustergen_f0_trees uba_es_secty::clustergen_f0_trees))

        (if cg:mixed_excitation
            (set! me_filter_track 
                  (track.load 
                   (string-append uba_es_secty::dir "/"
                                  "festvox/mef.track"))))
        (if cg:mlsa_lpf
            (set! lpf_track 
                  (track.load 
                   (string-append uba_es_secty::dir "/"
                                  "festvox/lpf.track"))))
        (if (and cg:rfs (boundp 'uba_es_secty:rfs_models))
            (set! cg:rfs_models uba_es_secty:rfs_models))
        (if (and cg:rfs_dur (boundp 'uba_es_secty:rfs_dur_models))
            (set! cg:rfs_dur_models uba_es_secty:rfs_dur_models))

	(Parameter.set 'Synth_Method 'ClusterGen)
      ))

  ;; This is where you can modify power (and sampling rate) if desired
  (set! after_synth_hooks nil)
;  (set! after_synth_hooks
;      (list
;        (lambda (utt)
;          (utt.wave.rescale utt 2.1))))

  (set! current_voice_reset uba_es_secty::voice_reset)

  (set! current-voice 'uba_es_secty_cg)
)

(define (is_pau i)
  (if (phone_is_silence (item.name i))
      "1"
      "0"))

(provide 'uba_es_secty_cg)

