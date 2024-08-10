(ns clj-playground.core-test
  (:require
    [clojure.test :refer [deftest is]]
    [clj-playground.core :as core]))

(deftest greet-test
  (is (= (core/greet) "hi")))

