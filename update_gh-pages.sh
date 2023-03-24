#!/usr/bin/env bash

set -eo

TARGET="scalamatsuri2023"

if [[ ! $(git rev-parse --verify gh-pages 2>/dev/null) ]]; then
  git checkout --orphan gh-pages
  git rm -rf .
  git clean -fxd
  git commit --allow-empty -m 'Dummy commit'
  git checkout master
fi

make

if [ $? != 0 ]; then
  make clean
  make
fi
  
if [ $? = 0 ] && [ -f "${TARGET}.pdf" ] && \
   [ -f "${TARGET}_without_animation.pdf" ]; then
  git stash -a
  git checkout gh-pages
  rm "${TARGET}.pdf" "${TARGET}_without_animation.pdf" || echo "Fail to delete!"
  git stash pop
  git add "${TARGET}.pdf" "${TARGET}_without_animation.pdf"
  git commit -m 'Update PDFs'
  git push origin gh-pages
  git checkout master
fi
