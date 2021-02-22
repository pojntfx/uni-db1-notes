while inotifywait -e modify .; do
    ./compile.sh
done
