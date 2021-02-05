# Japanese Vocabulary

## なん ですか。

It's a small package that might be use to add Japanese vocabulary to your
vocabulary list from anywhere!
Why Japanese and not a general package for any language you might ask ?
Because I'm still learning how to make Emacs package and templating for
general usage seemed tedious. For exemple, I splitted the vocabulary in three
lists (verbs, name and adjectives) where someone else may want everything in
one. Plus, some languages have different genders, or you might want to specify
the group of the verb and so on...
I might make a more general package in the futur, but I've got bigger projects
to work on yet.

## Installation

If you are not using use-package, you'll have to manage the installation yourself,
otherwise just add this to your config file.

``` emacs-lisp
(use-package japanese-vocabulary :ensure t :recipe (:host github :repo "Luceurre/emacs-japanese-vocabulary"))
```

## Configuration

You might want to specify the files in which your data is stored. You can do
this by setting the following variables :

- `luceurre/japanese-vocabulary-directory`: the locations for the files (default: "~/Documents/Japanese/Vocabulaire/").
- `luceurre/japanese-WHATEVER-fileneme`: the file where WHATEVER is stored (default: "WHATEVER.csv").

## Usage

You have to enable the minor mode to use this package.
This can be done with `(luceurre/japanese-vocabulary-mode t)`.
Don't forget to set the pathes before!

Once the minor mode active, you can use the following commands to add or display
you vocabulary from anywhere :

- `luceurre/japanese-add-WHATEVER`: add vocabulary to the WHATEVER list.
- `luceurre/japanese-dump-WHATEVER-to-org-table`: create a temp buffer in org mode and display WHATEVER list in it.


