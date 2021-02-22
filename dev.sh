while inotifywait -e modify .; do
    for document in *.md; do
        echo "Compiling $document ..."
        pandoc "$document" -o "$document.pdf"
    done
done
