#!/usr/bin/env bash


git checkout .

git pull

git rev-parse --short HEAD

echo pip -V

#sed  -i 's/timeout=5/timeout=os.environ.get(\"SEARCH_TIME\")/' app.py

#sed  -i 's/ali = "" \"\"/import os \nali = os.environ.get(\"REFRESH_TOKEN\")/' utils/ali.py

gunicorn -w 4 -b 0.0.0.0:8080 app:app