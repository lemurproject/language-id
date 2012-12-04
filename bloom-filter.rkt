#lang racket

; Lightning fast boolean searches (membership test)
; Small memory footprint


; A bloom filter gives us:
;; Constant time searches
;; #t or #f for set membership
;; memory efficient
;; every element hashed to one or more indices in an array of bits
;; So each element = 3 bits (for 3 hash functions i.e.)
;; But bloom filters are even better!!
;; Allow hash collisions and memory usage lower

;; a list of boolean values
;; length of list = width of bloom filter

;;; Insert:
;;;; k different hash indicer and set them to true
;;;; compute hash indices and set them all to true
;;;; if they are already true, nobody gives a shit

;;; Removal:
;;;; Not on the agenda

(require (planet dvanhorn/fector:1:1))

;; fector is used to maintain the set

(struct bloom-filter (size width K hash [v #:mutable]) #:transparent)
(provide (struct-out bloom-filter))

(define (member? ele bf)
  (let* ((bf-K (bloom-filter-K bf))
	 (bf-size (bloom-filter-size bf))
	 (bf-width (bloom-filter-width bf))
	 (bf-vector (bloom-filter-v bf))
	 (bf-hash (bloom-filter-hash bf))
	 (ele-hash-indices (map (lambda (x) (bf-hash ele x bf-width)) (sequence->list (in-range bf-K))))
	 (ele-hash-vals (map (lambda (x) (vector-ref bf-vector x)) ele-hash-indices)))
    (foldl (lambda (x y) (and x y)) #t ele-hash-vals)))
(provide member?)

(define (add ele bf)
  (let* ((bf-K (bloom-filter-K bf))
	 (bf-size (bloom-filter-size bf))
	 (bf-width (bloom-filter-width bf))
	 (bf-hash (bloom-filter-hash bf))
	 (bf-vector (bloom-filter-v bf))
	 (ele-hash-indices (map (lambda (x) (bf-hash ele x bf-width)) (sequence->list (in-range bf-K)))))
      (map (lambda (k) (vector-set! bf-vector k #t)) ele-hash-indices)))
(provide add)

(define (dump bf filename)
  (write-to-file bf filename 'binary))
(provide dump)
