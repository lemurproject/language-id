#lang racket

;; common routines that I prefer

(define (bytes->int64s b)
  (map abs (for/list ([i (in-range 0 (bytes-length b) 4)])
	     (integer-bytes->integer (subbytes b i (+ i 4)) #t))))

(provide bytes->int64s)
