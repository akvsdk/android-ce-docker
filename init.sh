#!/usr/bin/env bash

#sed  -i 's/timeout=5/timeout=os.environ.get(\"SEARCH_TIME\")/' app.py

#sed  -i 's/ali = "" \"\"/import os \nali = os.environ.get(\"REFRESH_TOKEN\")/' utils/ali.py

BRANCH=main

LOCAL=$(git log $BRANCH -n 1 --pretty=format:"%H")
REMOTE=$(git log remotes/origin/$BRANCH -n 1 --pretty=format:"%H")

if [ $LOCAL = $REMOTE ]; then

    git checkout . && git pull

    pip install -i https://pypi.mirrors.ustc.edu.cn/simple/ -r requirements.txt && gunicorn -w 4 -b 0.0.0.0:8080 app:app

else
    gunicorn -w 4 -b 0.0.0.0:8080 app:app
fi