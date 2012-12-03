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

(define-struct bloom-filter (size width K bf-fector))

