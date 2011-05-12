" Language:    Coco
" Maintainer:  satyr
" URL:         http://github.com/satyr/vim-coco
" License:     WTFPL

if exists("b:current_syntax")
  finish
endif

if version < 600
  syntax clear
endif

let b:current_syntax = "co"

" Highlight long strings.
syntax sync minlines=100

" CoffeeScript allows dollar signs in identifiers.
setlocal isident+=$

" These are 'matches' rather than 'keywords' because vim's highlighting priority
" for keywords (the highest) causes them to be wrongly highlighted when used as
" dot-properties.
syntax match coStatement /\<\%(return\|break\|continue\|throw\)\>/
highlight default link coStatement Statement

syntax match coRepeat /\<\%(for\%( own\| ever\)\?\|while\|until\)\>/
highlight default link coRepeat Repeat

syntax match coConditional /\<\%(if\|else\|unless\|switch\|case\|default\)\>/
highlight default link coConditional Conditional

syntax match coException /\<\%(try\|catch\|finally\)\>/
highlight default link coException Exception

syntax match coOperator /\<\%(new\|in\%(stanceof\)\?\|typeof\|delete\|and\|o[fr]\|not\|is\|import\%( all\)\?\|extends\|from\|to\|by\)\>/
highlight default link coOperator Operator

syntax match coKeyword /\<\%(this\|arguments\|do\|then\|function\|class\|let\|with\|eval\|super\)\>/
highlight default link coKeyword Keyword

syntax match coBoolean /\<\%(true\|false\|null\|void\)\>/
highlight default link coBoolean Boolean

" Keywords reserved by the language
syntax cluster coReserved contains=coStatement,coRepeat,coConditional,
\                                  coException,coOperator,coKeyword,
\                                  coBoolean

" Matches @-variables like @abc.
syntax match coVar /@@\?\%(\I\i*\)\?/
highlight default link coVar Type

" Matches class-like names that start with a capital letter, like Array or
" Object.
syntax match coObject /\<\u\w*\>/
highlight default link coObject Structure

" Matches constant-like names in SCREAMING_CAPS.
syntax match coConstant /\<\u[A-Z0-9_]\+\>/
highlight default link coConstant Constant

" What can make up a variable name
syntax cluster coIdentifier contains=coVar,coObject,coConstant,
\                                        coPrototype

syntax region coString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@coInterpString
syntax region coString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@coSimpleString
highlight default link coString String

" Matches numbers like -10, -10e8, -10E8, 10, 10e8, 10E8.
syntax match coNumber /\i\@<![-+]\?\d\+\%([eE][+-]\?\d\+\)\?/
" Matches hex numbers like 0xfff, 0x000.
syntax match coNumber /\<0[xX]\x\+\>/
highlight default link coNumber Number

" Matches floating-point numbers like -10.42e8, 10.42e-8.
syntax match coFloat /\i\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/
highlight default link coFloat Float

syntax match coAssignSymbols /:\@<!::\@!\|++\|--\|\%(\%(\s\zs\%(and\|or\)\)\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!/ contained
highlight default link coAssignSymbols SpecialChar

syntax match coAssignBrackets /\[.\+\]/ contained contains=TOP,coAssign

syntax match coAssign /[}\]]\@<=\s*==\@!>\@!/ contains=coAssignSymbols
syntax match coAssign /\%(++\|--\)\s*\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*/
\                         contains=@coIdentifier,coAssignSymbols,coAssignBrackets
syntax match coAssign /\%(@\|@\?\I\)\%(\i\|::\|\.\|?\|\[.\+\]\)*\%(++\|--\|\s*\%(and\|or\|&&\|||\|?\|+\|-\|\/\|\*\|%\|<<\|>>\|>>>\|&\||\|\^\)\?=\@<!==\@!>\@!\)/
\                         contains=@coIdentifier,coAssignSymbols,coAssignBrackets

" Displays an error for reserved words.
if !exists("co_no_reserved_words_error")
  syntax match coReservedError /\<\%(const\|enum\|export\)\>/
  highlight default link coReservedError Error
endif

syntax match coPrototype /::/
highlight default link coPrototype SpecialChar

syntax match coFunction /[-~]>/
highlight default link coFunction Function

syntax keyword coTodo TODO FIXME XXX contained
highlight default link coTodo Todo

syntax match coComment /#.*/ contains=@Spell,coTodo
highlight default link coComment Comment

syntax region coEmbed start=/`/ skip=/\\\\\|\\`/ end=/`/
highlight default link coEmbed Special

syntax region coInterpolation matchgroup=coInterpDelim
\                                 start=/\#{/ end=/}/
\                                 contained contains=TOP
highlight default link coInterpDelim Delimiter

" Matches escape sequences like \000, \x00, \u0000, \n.
syntax match coEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained
highlight default link coEscape SpecialChar

" What is in a non-interpolated string
syntax cluster coSimpleString contains=@Spell,coEscape
" What is in an interpolated string
syntax cluster coInterpString contains=@coSimpleString,
\                                           coInterpolation

syntax region coRegex start=/\%(\%()\|\i\@<!\d\)\s*\|\i\)\@<!\/\s\@!/
\                         skip=/\[[^]]\{-}\/[^]]\{-}\]/
\                         end=/\/[gimy]\{,4}\d\@!/
\                         oneline contains=@coSimpleString
syntax region coHeregex start=/\/\// end=/\/\/\%(?\|[gimy]\{,4}\)/ contains=@coInterpString,coComment fold
highlight default link coHeregex coRegex
highlight default link coRegex String

syntax region coHeredoc start=/"""/ end=/"""/ contains=@coInterpString fold
syntax region coHeredoc start=/'''/ end=/'''/ contains=@coSimpleString fold
highlight default link coHeredoc String

" Displays an error for trailing whitespace.
if !exists("co_no_trailing_space_error")
  syntax match coSpaceError /\S\@<=\s\+$/ display
  highlight default link coSpaceError Error
endif

" Displays an error for trailing semicolons.
if !exists("co_no_trailing_semicolon_error")
  syntax match coSemicolonError /;$/ display
  highlight default link coSemicolonError Error
endif

" Reserved words can be used as dot-properties.
syntax match coDot /\.\@<!\.\i\+/ transparent
\                                     contains=ALLBUT,@coReserved,
\                                                      coReservedError

