" Vim syntax file
" Language:		Mirah
" Maintainer:		James Britt - james@neurogami.com
" Info:			
" URL:		
" Release Coordinator:	Probably Jimbo, right?
" ----------------------------------------------------------------------------
"
" ----------------------------------------------------------------------------

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if has("folding") && exists("mirah_fold")
  setlocal foldmethod=syntax
endif

if exists("mirah_space_errors")
  if !exists("mirah_no_trail_space_error")
    syn match mirahSpaceError display excludenl "\s\+$"
  endif
  if !exists("mirah_no_tab_space_error")
    syn match mirahSpaceError display " \+\t"me=e-1
  endif
endif

" Operators
if exists("mirah_operators")
  syn match  mirahOperator        "\%(\^\|\~\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|>\||\|-\|/\|\*\*\|\*\|&\|%\|+\)"
  syn match  mirahPseudoOperator  "\%(-=\|/=\|\*\*=\|\*=\|&&\|&=\|&&=\|||\||=\|||=\|%=\|+=\|!\~\|!=\)"
  syn region mirahBracketOperator matchgroup=mirahOperator start="\%([_[:lower:]]\w*[?!=]\=\|}\)\@<=\[\s*" end="\s*]"
endif

" Expression Substitution and Backslash Notation
syn match mirahEscape		"\\\\\|\\[abefnrstv]\|\\\o\{1,3}\|\\x\x\{1,2}"								contained display
syn match mirahEscape		"\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)"	contained display
syn match mirahInterpolation	"#{[^}]*}"				contained
syn match mirahInterpolation	"#\%(\$\|@@\=\)\w\+"			contained display
syn match mirahNoInterpolation	"\\#{[^}]*}"				contained
syn match mirahNoInterpolation	"\\#\%(\$\|@@\=\)\w\+"			contained display

syn match mirahDelimEscape	"\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region mirahNestedParentheses	start="("	end=")"		skip="\\\\\|\\)"	transparent contained contains=@mirahStringSpecial,mirahNestedParentheses,mirahDelimEscape
syn region mirahNestedCurlyBraces	start="{"	end="}"		skip="\\\\\|\\}"	transparent contained contains=@mirahStringSpecial,mirahNestedCurlyBraces,mirahDelimEscape
syn region mirahNestedAngleBrackets	start="<"	end=">"		skip="\\\\\|\\>"	transparent contained contains=@mirahStringSpecial,mirahNestedAngleBrackets,mirahDelimEscape
syn region mirahNestedSquareBrackets	start="\["	end="\]"	skip="\\\\\|\\\]"	transparent contained contains=@mirahStringSpecial,mirahNestedSquareBrackets,mirahDelimEscape

syn cluster mirahStringSpecial		contains=mirahInterpolation,mirahNoInterpolation,mirahEscape
syn cluster mirahExtendedStringSpecial	contains=@mirahStringSpecial,mirahNestedParentheses,mirahNestedCurlyBraces,mirahNestedAngleBrackets,mirahNestedSquareBrackets

" Numbers and ASCII Codes
syn match mirahASCIICode	"\w\@<!\%(?\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\=\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)\)"
syn match mirahInteger	"\<0[xX]\x\+\%(_\x\+\)*\>"								display
syn match mirahInteger	"\<\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)\>"						display
syn match mirahInteger	"\<0[oO]\=\o\+\%(_\o\+\)*\>"								display
syn match mirahInteger	"\<0[bB][01]\+\%(_[01]\+\)*\>"								display
syn match mirahFloat	"\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\.\d\+\%(_\d\+\)*\>"					display
syn match mirahFloat	"\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\%(\.\d\+\%(_\d\+\)*\)\=\%([eE][-+]\=\d\+\%(_\d\+\)*\)\>"	display

" Identifiers
syn match mirahLocalVariableOrMethod "\<[_[:lower:]][_[:alnum:]]*[?!=]\=" contains=NONE display transparent
syn match mirahBlockArgument	    "&[_[:lower:]][_[:alnum:]]"		 contains=NONE display transparent

syn match  mirahConstant			"\%(\%(\.\@<!\.\)\@<!\<\|::\)\_s*\zs\u\w*\>\%(\s*(\)\@!"
syn match  mirahClassVariable		"@@\h\w*" display
syn match  mirahInstanceVariable		"@\h\w*"  display
syn match  mirahGlobalVariable		"$\%(\h\w*\|-.\)"
syn match  mirahSymbol			":\@<!:\%(\^\|\~\|<<\|<=>\|<=\|<\|===\|==\|=\~\|>>\|>=\|>\||\|-@\|-\|/\|\[]=\|\[]\|\*\*\|\*\|&\|%\|+@\|+\|`\)"
syn match  mirahSymbol			":\@<!:\$\%(-.\|[`~<=>_,;:!?/.'"@$*\&+0]\)"
syn match  mirahSymbol			":\@<!:\%(\$\|@@\=\)\=\h\w*[?!=]\="
syn region mirahSymbol			start=":\@<!:\"" end="\"" skip="\\\\\|\\\""
if exists("mirah_operators")
  syn match  mirahBlockParameter		"\%(\%(\%(\<do\>\|{\)\s*\)|\s*\)\@<=[( ,a-zA-Z0-9_*)]\+\%(\s*|\)\@=" display
else
  syn match  mirahBlockParameter		"\%(\%(\<do\>\|{\)\s*\)\@<=|\s*\zs[( ,a-zA-Z0-9_*)]\+\ze\s*|" display
endif

syn match mirahPredefinedVariable #$[!$&"'*+,./0:;<=>?@\`~1-9]#
syn match mirahPredefinedVariable "$_\>"											   display
syn match mirahPredefinedVariable "$-[0FIKadilpvw]\>"									   display
syn match mirahPredefinedVariable "$\%(deferr\|defout\|stderr\|stdin\|stdout\)\>"					   display
syn match mirahPredefinedVariable "$\%(DEBUG\|FILENAME\|KCODE\|LOADED_FEATURES\|LOAD_PATH\|PROGRAM_NAME\|SAFE\|VERBOSE\)\>" display
syn match mirahPredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(MatchingData\|ARGF\|ARGV\|ENV\)\>\%(\s*(\)\@!"
syn match mirahPredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(DATA\|FALSE\|NIL\|RUBY_PLATFORM\|RUBY_RELEASE_DATE\)\>\%(\s*(\)\@!"
syn match mirahPredefinedConstant "\%(\%(\.\@<!\.\)\@<!\|::\)\_s*\zs\%(RUBY_VERSION\|STDERR\|STDIN\|STDOUT\|TOPLEVEL_BINDING\|TRUE\)\>\%(\s*(\)\@!"
"Obsolete Global Constants
"syn match mirahPredefinedConstant "\%(::\)\=\zs\%(PLATFORM\|RELEASE_DATE\|VERSION\)\>"
"syn match mirahPredefinedConstant "\%(::\)\=\zs\%(NotImplementError\)\>"

" Normal Regular Expression
syn region mirahString matchgroup=mirahStringDelimiter start="\%(\%(^\|\<\%(and\|or\|while\|until\|unless\|if\|elsif\|when\|not\|then\)\|[;\~=!|&(,[>]\)\s*\)\@<=/" end="/[iomx]*" skip="\\\\\|\\/" contains=@mirahStringSpecial fold
syn region mirahString matchgroup=mirahStringDelimiter start="\%(\<\%(split\|scan\|gsub\|sub\)\s*\)\@<=/" end="/[iomx]*" skip="\\\\\|\\/" contains=@mirahStringSpecial fold

" Normal String and Shell Command Output
syn region mirahString matchgroup=mirahStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@mirahStringSpecial fold
syn region mirahString matchgroup=mirahStringDelimiter start="'"	end="'"  skip="\\\\\|\\'"			       fold
syn region mirahString matchgroup=mirahStringDelimiter start="`"	end="`"  skip="\\\\\|\\`"  contains=@mirahStringSpecial fold

" Generalized Regular Expression
syn region mirahString matchgroup=mirahStringDelimiter start="%r\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)"	end="\z1[iomx]*" skip="\\\\\|\\\z1" contains=@mirahStringSpecial fold
syn region mirahString matchgroup=mirahStringDelimiter start="%r{"				end="}[iomx]*"	 skip="\\\\\|\\}"   contains=@mirahStringSpecial,mirahNestedCurlyBraces,mirahDelimEscape fold
syn region mirahString matchgroup=mirahStringDelimiter start="%r<"				end=">[iomx]*"	 skip="\\\\\|\\>"   contains=@mirahStringSpecial,mirahNestedAngleBrackets,mirahDelimEscape fold
syn region mirahString matchgroup=mirahStringDelimiter start="%r\["				end="\][iomx]*"	 skip="\\\\\|\\\]"  contains=@mirahStringSpecial,mirahNestedSquareBrackets,mirahDelimEscape fold
syn region mirahString matchgroup=mirahStringDelimiter start="%r("				end=")[iomx]*"	 skip="\\\\\|\\)"   contains=@mirahStringSpecial,mirahNestedParentheses,mirahDelimEscape fold

" Generalized Single Quoted String, Symbol and Array of Strings
syn region mirahString matchgroup=mirahStringDelimiter start="%[qsw]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" fold
syn region mirahString matchgroup=mirahStringDelimiter start="%[qsw]{"				    end="}"   skip="\\\\\|\\}"	 fold	contains=mirahNestedCurlyBraces,mirahDelimEscape
syn region mirahString matchgroup=mirahStringDelimiter start="%[qsw]<"				    end=">"   skip="\\\\\|\\>"	 fold	contains=mirahNestedAngleBrackets,mirahDelimEscape
syn region mirahString matchgroup=mirahStringDelimiter start="%[qsw]\["				    end="\]"  skip="\\\\\|\\\]"	 fold	contains=mirahNestedSquareBrackets,mirahDelimEscape
syn region mirahString matchgroup=mirahStringDelimiter start="%[qsw]("				    end=")"   skip="\\\\\|\\)"	 fold	contains=mirahNestedParentheses,mirahDelimEscape

" Generalized Double Quoted String and Array of Strings and Shell Command Output
" Note: %= is not matched here as the beginning of a double quoted string
syn region mirahString matchgroup=mirahStringDelimiter start="%\z([~`!@#$%^&*_\-+|\:;"',.?/]\)"	    end="\z1" skip="\\\\\|\\\z1" contains=@mirahStringSpecial fold
syn region mirahString matchgroup=mirahStringDelimiter start="%[QWx]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" contains=@mirahStringSpecial fold
syn region mirahString matchgroup=mirahStringDelimiter start="%[QWx]\={"				    end="}"   skip="\\\\\|\\}"	 contains=@mirahStringSpecial,mirahNestedCurlyBraces,mirahDelimEscape fold
syn region mirahString matchgroup=mirahStringDelimiter start="%[QWx]\=<"				    end=">"   skip="\\\\\|\\>"	 contains=@mirahStringSpecial,mirahNestedAngleBrackets,mirahDelimEscape fold
syn region mirahString matchgroup=mirahStringDelimiter start="%[QWx]\=\["				    end="\]"  skip="\\\\\|\\\]"	 contains=@mirahStringSpecial,mirahNestedSquareBrackets,mirahDelimEscape fold
syn region mirahString matchgroup=mirahStringDelimiter start="%[QWx]\=("				    end=")"   skip="\\\\\|\\)"	 contains=@mirahStringSpecial,mirahNestedParentheses,mirahDelimEscape fold

" Here Document
syn region mirahHeredocStart matchgroup=mirahStringDelimiter start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-\=\zs\%(\h\w*\)+   end=+$+ oneline contains=TOP
syn region mirahHeredocStart matchgroup=mirahStringDelimiter start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-\=\zs"\%([^"]*\)"+ end=+$+ oneline contains=TOP
syn region mirahHeredocStart matchgroup=mirahStringDelimiter start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-\=\zs'\%([^']*\)'+ end=+$+ oneline contains=TOP
syn region mirahHeredocStart matchgroup=mirahStringDelimiter start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-\=\zs`\%([^`]*\)`+ end=+$+ oneline contains=TOP

syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<\z(\h\w*\)\ze+hs=s+2    matchgroup=mirahStringDelimiter end=+^\z1$+ contains=mirahHeredocStart,@mirahStringSpecial nextgroup=mirahFunction fold keepend
syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<"\z([^"]*\)"\ze+hs=s+2  matchgroup=mirahStringDelimiter end=+^\z1$+ contains=mirahHeredocStart,@mirahStringSpecial nextgroup=mirahFunction fold keepend
syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<'\z([^']*\)'\ze+hs=s+2  matchgroup=mirahStringDelimiter end=+^\z1$+ contains=mirahHeredocStart		      nextgroup=mirahFunction fold keepend
syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<`\z([^`]*\)`\ze+hs=s+2  matchgroup=mirahStringDelimiter end=+^\z1$+ contains=mirahHeredocStart,@mirahStringSpecial nextgroup=mirahFunction fold keepend

syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-\z(\h\w*\)\ze+hs=s+3    matchgroup=mirahStringDelimiter end=+^\s*\zs\z1$+ contains=mirahHeredocStart,@mirahStringSpecial nextgroup=mirahFunction fold keepend
syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-"\z([^"]*\)"\ze+hs=s+3  matchgroup=mirahStringDelimiter end=+^\s*\zs\z1$+ contains=mirahHeredocStart,@mirahStringSpecial nextgroup=mirahFunction fold keepend
syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-'\z([^']*\)'\ze+hs=s+3  matchgroup=mirahStringDelimiter end=+^\s*\zs\z1$+ contains=mirahHeredocStart		     nextgroup=mirahFunction fold keepend
syn region mirahString start=+\%(\%(class\s*\|\%(\.\|::\)\)\_s*\)\@<!<<-`\z([^`]*\)`\ze+hs=s+3  matchgroup=mirahStringDelimiter end=+^\s*\zs\z1$+ contains=mirahHeredocStart,@mirahStringSpecial nextgroup=mirahFunction fold keepend

if exists('main_syntax') && main_syntax == 'emirah'
  let b:mirah_no_expensive = 1
end

" Expensive Mode - colorize *end* according to opening statement
if !exists("b:mirah_no_expensive") && !exists("mirah_no_expensive")
  syn region mirahFunction matchgroup=mirahDefine start="\<def\s\+"    end="\%(\s*\%(\s\|(\|;\|$\|#\)\)\@=" oneline
  syn region mirahClass	  matchgroup=mirahDefine start="\<class\s\+"  end="\%(\s*\%(\s\|<\|;\|$\|#\)\)\@=" oneline
  syn match  mirahDefine   "\<class\ze<<"
  syn region mirahModule   matchgroup=mirahDefine start="\<module\s\+" end="\%(\s*\%(\s\|;\|$\|#\)\)\@="	  oneline

  syn region mirahBlock start="\<def\>"	  matchgroup=mirahDefine end="\<end\>" contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo nextgroup=mirahFunction fold
  syn region mirahBlock start="\<class\>"  matchgroup=mirahDefine end="\<end\>" contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo nextgroup=mirahClass	 fold
  syn region mirahBlock start="\<module\>" matchgroup=mirahDefine end="\<end\>" contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo nextgroup=mirahModule	 fold

  " modifiers
  syn match  mirahControl "\<\%(if\|unless\|while\|until\)\>" display

  " *do* requiring *end*
  syn region mirahDoBlock matchgroup=mirahControl start="\<do\>" end="\<end\>" contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo fold

  " *{* requiring *}*
  syn region mirahCurlyBlock start="{" end="}" contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo fold

  " statements without *do*
  syn region mirahNoDoBlock matchgroup=mirahControl start="\<\%(case\|begin\)\>" start="\%(^\|\.\.\.\=\|[,;=([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\zs\%(if\|unless\)\>" end="\<end\>" contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo fold

  " statement with optional *do*
  syn region mirahOptDoLine matchgroup=mirahControl start="\<for\>" start="\%(\%(^\|\.\.\.\=\|[?:,;=([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" end="\%(\<do\>\|:\)" end="\ze\%(;\|$\)" oneline contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo
  syn region mirahOptDoBlock start="\<for\>" start="\%(\%(^\|\.\.\.\=\|[:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" matchgroup=mirahControl end="\<end\>" contains=ALLBUT,@mirahExtendedStringSpecial,mirahTodo nextgroup=mirahOptDoLine fold

  if !exists("mirah_minlines")
    let mirah_minlines = 50
  endif
  exec "syn sync minlines=" . mirah_minlines

else
  syn region  mirahFunction matchgroup=mirahControl start="\<def\s\+"    end="\ze\%(\s\|(\|;\|$\)" oneline
  syn region  mirahClass    matchgroup=mirahControl start="\<class\s\+"  end="\ze\%(\s\|<\|;\|$\)" oneline
  syn match   mirahControl  "\<class\ze<<"
  syn region  mirahModule   matchgroup=mirahControl start="\<module\s\+" end="\ze\%(\s\|;\|$\)"	 oneline
  syn keyword mirahControl case begin do for if unless while until end
endif

" Keywords
" Note: the following keywords have already been defined:
" begin case class def do end for if module unless until while
syn keyword mirahControl		and break else elsif ensure in next not or redo rescue retry return then when
syn match   mirahOperator	"\<defined?" display
syn keyword mirahKeyword		alias super undef yield
syn keyword mirahBoolean		true false
syn keyword mirahPseudoVariable	nil self __FILE__ __LINE__
syn keyword mirahBeginEnd	BEGIN END

" Special Methods
if !exists("mirah_no_special_methods")
  syn keyword mirahAccess    public protected private
  syn keyword mirahAttribute attr attr_accessor attr_reader attr_writer
  syn match   mirahControl   "\<\%(exit!\|\%(abort\|at_exit\|exit\|fork\|loop\|trap\)\>\)"
  syn keyword mirahEval	    eval class_eval instance_eval module_eval
  syn keyword mirahException raise fail catch throw
  syn keyword mirahInclude   autoload extend include load require import
  syn keyword mirahKeyword   callcc caller lambda proc implements
endif

" Comments and Documentation
syn match   mirahSharpBang     "\%^#!.*" display
syn keyword mirahTodo	      FIXME NOTE TODO XXX contained
syn match   mirahComment       "#.*" contains=mirahSharpBang,mirahSpaceError,mirahTodo,@Spell
if !exists("mirah_no_comment_fold")
  syn region mirahMultilineComment start="\%(\%(^\s*#.*\n\)\@<!\%(^\s*#.*\n\)\)\%(\(^\s*#.*\n\)\{1,}\)\@=" end="\%(^\s*#.*\n\)\@<=\%(^\s*#.*\n\)\%(^\s*#\)\@!" contains=mirahComment transparent fold keepend
  syn region mirahDocumentation    start="^=begin\s*$" end="^=end\s*$" contains=mirahSpaceError,mirahTodo,@Spell fold
else
  syn region mirahDocumentation    start="^=begin\s*$" end="^=end\s*$" contains=mirahSpaceError,mirahTodo,@Spell
endif

" Note: this is a hack to prevent 'keywords' being highlighted as such when called as methods with an explicit receiver
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(alias\|and\|begin\|break\|case\|class\|def\|defined\|do\|else\)\>"			transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(elsif\|end\|ensure\|false\|for\|if\|in\|module\|next\|nil\)\>"			transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(not\|or\|redo\|rescue\|retry\|return\|self\|super\|then\|true\)\>"			transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(undef\|unless\|until\|when\|while\|yield\|BEGIN\|END\|__FILE__\|__LINE__\)\>"	transparent contains=NONE

syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(abort\|at_exit\|attr\|attr_accessor\|attr_reader\)\>"	transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(attr_writer\|autoload\|callcc\|catch\|caller\)\>"		transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(eval\|class_eval\|instance_eval\|module_eval\|exit\)\>"	transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(extend\|fail\|fork\|include\|lambda\)\>"			transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(load\|loop\|private\|proc\|protected\)\>"			transparent contains=NONE
syn match mirahKeywordAsMethod "\%(\%(\.\@<!\.\)\|::\)\_s*\%(public\|require\|raise\|throw\|trap\)\>"			transparent contains=NONE
syn match mirahLParen "("			display
syn match mirahRParen ")"			display

" __END__ Directive
syn region mirahData matchgroup=mirahDataDirective start="^__END__$" end="\%$" fold

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_mirah_syntax_inits")
  if version < 508
    let did_mirah_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink mirahRParen                    JGBParens
  HiLink mirahLParen                    JGBParens
  HiLink mirahDefine			Define
  HiLink mirahFunction			Function
  HiLink mirahControl			Statement
  HiLink mirahInclude			Include
  HiLink mirahInteger			Number
  HiLink mirahASCIICode			mirahInteger
  HiLink mirahFloat			Float
  HiLink mirahBoolean			mirahPseudoVariable
  HiLink mirahException			Exception
  HiLink mirahClass			Type
  HiLink mirahModule			Type
  if !exists("mirah_no_identifiers")
    HiLink mirahIdentifier		Identifier
  else
    HiLink mirahIdentifier		NONE
  endif
  HiLink mirahClassVariable		mirahIdentifier
  HiLink mirahConstant			mirahIdentifier
  HiLink mirahGlobalVariable		mirahIdentifier
  HiLink mirahBlockParameter		mirahIdentifier
  HiLink mirahInstanceVariable		mirahIdentifier
  HiLink mirahPredefinedIdentifier	mirahIdentifier
  HiLink mirahPredefinedConstant	mirahPredefinedIdentifier
  HiLink mirahPredefinedVariable	mirahPredefinedIdentifier
  HiLink mirahSymbol			mirahIdentifier
  HiLink mirahKeyword			Keyword
  HiLink mirahOperator			Operator
  HiLink mirahPseudoOperator		mirahOperator
  HiLink mirahBeginEnd			Statement
  HiLink mirahAccess			Statement
  HiLink mirahAttribute			Statement
  HiLink mirahEval			Statement
  HiLink mirahPseudoVariable		Constant

  HiLink mirahComment			Comment
  HiLink mirahData			Comment
  HiLink mirahDataDirective		Delimiter
  HiLink mirahDocumentation		Comment
  HiLink mirahEscape			Special
  HiLink mirahInterpolation		Special
  HiLink mirahNoInterpolation		mirahString
  HiLink mirahSharpBang			PreProc
  HiLink mirahStringDelimiter		Delimiter
  HiLink mirahString			String
  HiLink mirahTodo			Todo

  HiLink mirahError			Error
  HiLink mirahSpaceError		mirahError

  delcommand HiLink
endif

let b:current_syntax = "mirah"

" vim: nowrap sw=2 sts=2 ts=8 ff=unix:
