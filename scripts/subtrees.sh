#!/usr/bin/env bash

git remote add -f bootstrap-datepicker https://github.com/eternicode/bootstrap-datepicker.git
git subtree add --prefix public/js/ext/bootstrap-datepicker bootstrap-datepicker master --squash
