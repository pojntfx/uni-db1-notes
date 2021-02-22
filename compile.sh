for document in *.md; do
    echo "Compiling $document ..."
    docker run -v "$PWD:/data:z" pandoc/latex "$document" -o "$document.pdf"
done
