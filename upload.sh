#!/bin/bash
git add .
d=$(date)
git commit -m "$d"
git push origin master