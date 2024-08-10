(ns clj-playground.core
  (:gen-class))

(defn ^:export greet []
  "hi")

(defn -main
  [& args]
  (println "hello world"))

