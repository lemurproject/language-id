#lang racket

; Module to discover the language being used on a webpage

(require (planet dvanhorn/fector:1:1))
(require (planet vyzo/crypto))
(require srfi/1)

(require "bloom-filter.rkt")
(require "common.rkt")

(define (hash e k bounds)
  (remainder
   (if (= 0 k)
       (first (bytes->int64s (sha1 (string->bytes/locale e))))
       (bitwise-xor k (hash e (- k 1) bounds)))
   bounds))

(define *WIDTH* 2000000)

(define (compute-k vocab-size)
   (quotient
    (* 9 *WIDTH*)
    (* 13 vocab-size)))

(define (get-vocab-size word-list-file)
  (length (file->lines word-list-file)))

(define *VOCAB-SIZE* (get-vocab-size "english"))

(define *BLOOM-FILTER* (bloom-filter 
			*VOCAB-SIZE*
			*WIDTH*
			(compute-k *VOCAB-SIZE*)
			hash
			(make-vector *WIDTH* #f)))

(define (load-english-word-list word-list-file)
  (for ((e (file->lines word-list-file)))
	   (add e *BLOOM-FILTER*)))


