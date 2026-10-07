%% upolthesis.cls -- theses at the Faculty of Arts, Palacký University Olomouc
%%
%% A thin layer over the standard `report' class.  The faculty-wide parts
%% (FF-B-23/08: title page, declaration, annotation/abstract) live here;
%% department-specific layout and wording live in upolthesis-<dept>.def.
%%
%% Compile with LuaLaTeX (preferred) or XeLaTeX.
%%
%% Copyright 2026 Francis Bond.  LPPL 1.3c.
\NeedsTeXFormat{LaTeX2e}[2022-11-01]
\ProvidesClass{upolthesis}[2026/10/05 v0.1 FF UP Olomouc theses]

\RequirePackage{iftex}
\ifPDFTeX
  \ClassError{upolthesis}{This class needs LuaLaTeX or XeLaTeX}
    {Compile with lualatex (or xelatex), not pdflatex.}
\fi

%% ---------------------------------------------------------------- options
\newif\ifupol@autoref
\DeclareKeys[upol]{
  autoreferat.code = \upol@autoreftrue, % the autoreferát of a dissertation
  department.store = \upol@dept,     % kol (more to come: kas, kaa, kb)
  type.store       = \upol@type,     % ba | ma | phd
  language.store   = \upol@lang,     % czech | slovak | english
  gender.store     = \upol@gender,   % f | m | x (x prints "vypracoval/a")
  bib.store        = \upol@bib,      % apa | acl | none
  font.store       = \upol@font,     % pagella | charis | termes | none
  logo.store       = \upol@logo,     % shield | faculty | none
  spacing.store    = \upol@spacing,  % line stretch; empty = department default
  twoside.code     = \PassOptionsToClass{twoside,openright}{report},
}
\DeclareUnknownKeyHandler[upol]{\PassOptionsToClass{\CurrentOption}{report}}
\SetKeys[upol]{department=kol, type=ba, language=czech, gender=x, bib=apa,
  font=pagella, logo=shield, spacing=}
\ProcessKeyOptions[upol]

\LoadClass[a4paper,12pt]{report}
\ifupol@autoref\def\upol@type{phd}\fi

% language codes; the "national" abstract is Slovak for a Slovak thesis,
% otherwise Czech
\def\upol@langcode{cs}\def\upol@natcode{cs}\def\upol@natlang{czech}
\def\upol@tmp{english}\ifx\upol@lang\upol@tmp \def\upol@langcode{en}\fi
\def\upol@tmp{slovak}\ifx\upol@lang\upol@tmp
  \def\upol@langcode{sk}\def\upol@natcode{sk}\def\upol@natlang{slovak}\fi
\def\upol@tmp@en{en}
\def\upol@tmp@phd{phd}
\expandafter\def\csname upol@babel@cs\endcsname{czech}
\expandafter\def\csname upol@babel@sk\endcsname{slovak}
\expandafter\def\csname upol@babel@en\endcsname{english}

%% --------------------------------------------------------------- packages
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\defaultfontfeatures{Ligatures=TeX}
\edef\upol@tmp{\noexpand\RequirePackage
  [english,\upol@natlang,main=\upol@lang,provide*=*]{babel}}
\upol@tmp
\RequirePackage[autostyle]{csquotes}
\RequirePackage{graphicx}
\RequirePackage{xcolor}   % before (langsci-)gb4e, which can make ^ and _ active
\RequirePackage{geometry}
\RequirePackage{setspace}
\RequirePackage{titlesec}
\RequirePackage{zref-user,zref-totpages,zref-abspage}
\RequirePackage{siunitx}

%% ------------------------------------------------------------------ fonts
\newcommand\upol@setfont[2]{% #1 = font name, #2 = which (main/sans/mono)
  \IfFontExistsTF{#1}{\csname set#2font\endcsname{#1}}
    {\ClassWarning{upolthesis}{Font `#1' not found; keeping default}}}
\def\upol@tmp{pagella}\ifx\upol@font\upol@tmp
  \upol@setfont{TeX Gyre Pagella}{main}\upol@setfont{TeX Gyre Heros}{sans}\fi
\def\upol@tmp{termes}\ifx\upol@font\upol@tmp
  \upol@setfont{TeX Gyre Termes}{main}\upol@setfont{TeX Gyre Heros}{sans}\fi
\def\upol@tmp{charis}\ifx\upol@font\upol@tmp  % full IPA coverage
  \upol@setfont{Charis SIL}{main}\upol@setfont{TeX Gyre Heros}{sans}\fi
\def\upol@tmp{none}\ifx\upol@font\upol@tmp\else
  \upol@setfont{Inconsolata}{mono}\fi

%% ---------------------------------------------------------------- strings
%% \upol@defstr{key}{cs}{sk}{en}; \upol@str{key} uses the thesis language,
%% \upol@strin{lang}{key} a given one.  A key `key/<type>' (e.g.
%% `supervisor/phd') overrides `key' for that thesis type.
\newcommand\upol@defstr[4]{%
  \csdef{upol@s@#1@cs}{#2}\csdef{upol@s@#1@sk}{#3}\csdef{upol@s@#1@en}{#4}}
\newcommand\upol@strin[2]{%
  \ifcsdef{upol@s@#2/\upol@type @#1}
    {\csuse{upol@s@#2/\upol@type @#1}}{\csuse{upol@s@#2@#1}}}
\newcommand\upol@str[1]{\upol@strin{\upol@langcode}{#1}}

\upol@defstr{university}{Univerzita Palackého v~Olomouci}
  {Univerzita Palackého v~Olomouci}{Palacký University Olomouc}
\upol@defstr{faculty}{Filozofická fakulta}{Filozofická fakulta}{Faculty of Arts}
\upol@defstr{facultyuniv}{Filozofická fakulta Univerzity Palackého v~Olomouci}
  {Filozofická fakulta Univerzity Palackého v~Olomouci}
  {Faculty of Arts, Palacký University Olomouc}
% thesis type: nominative and accusative (for the declaration)
\upol@defstr{type@ba}{bakalářská práce}{bakalárska práca}{Bachelor's thesis}
\upol@defstr{type@ma}{diplomová práce}{diplomová práca}{Master's thesis}
\upol@defstr{type@phd}{disertační práce}{dizertačná práca}{Doctoral dissertation}
\upol@defstr{typeacc@ba}{bakalářskou práci}{bakalársku prácu}{bachelor's thesis}
\upol@defstr{typeacc@ma}{diplomovou práci}{diplomovú prácu}{master's thesis}
\upol@defstr{typeacc@phd}{disertační práci}{dizertačnú prácu}{doctoral dissertation}
\upol@defstr{author}{Autor}{Autor}{Author}
\upol@defstr{supervisor}{Vedoucí práce}{Vedúci práce}{Supervisor}
\upol@defstr{consultant}{Konzultant}{Konzultant}{Consultant}
\upol@defstr{supervisor/phd}{Školitel}{Školiteľ}{Supervisor}
\upol@defstr{declaration}{Prohlášení}{Vyhlásenie}{Declaration}
\upol@defstr{signature}{Podpis}{Podpis}{Signature}
\upol@defstr{inplace}{V~Olomouci dne}{V~Olomouci dňa}{Olomouc,}
\upol@defstr{aiuse}{Použití nástrojů umělé inteligence}
  {Použitie nástrojov umelej inteligencie}{Use of artificial intelligence tools}
\upol@defstr{ack}{Poděkování}{Poďakovanie}{Acknowledgements}
\upol@defstr{programme}{Studijní program}{Študijný program}{Study programme}
\upol@defstr{programmename}{\textbf{???}}{\textbf{???}}{\textbf{???}}
\upol@defstr{ipdecl}{Prohlášení o~duševním vlastnictví}
  {Vyhlásenie o~duševnom vlastníctve}{Intellectual property statement}
\upol@defstr{contrib}{Vyjádření o~autorském podílu}
  {Vyjadrenie o~autorskom podiele}{Statement of contribution}
\upol@defstr{autoref}{autoreferát disertační práce}
  {autoreferát dizertačnej práce}{summary of the doctoral dissertation}
\upol@defstr{summary}{Souhrn}{Súhrn}{Summary}
\upol@defstr{bibname}{Literatura a zdroje}{Literatúra a zdroje}{References}
% abstract page
\upol@defstr{abstract}{Abstrakt}{Abstrakt}{Abstract}
\upol@defstr{a@title}{Název práce}{Názov práce}{Title}
\upol@defstr{a@author}{Autor práce}{Autor práce}{Author}
\upol@defstr{a@extent}{Počet stran a znaků}{Počet strán a znakov}
  {Number of pages and characters}
\upol@defstr{a@pages}{stran}{strán}{pages}
\upol@defstr{a@chars}{znaků}{znakov}{characters}
\upol@defstr{a@app}{Počet příloh}{Počet príloh}{Number of appendices}
\upol@defstr{a@keywords}{Klíčová slova}{Kľúčové slová}{Keywords}

% the declaration sentence: \upol@declare@<lang>
\def\upol@g#1#2#3{% masculine / feminine / unspecified
  \if m\upol@gender #1\else\if f\upol@gender #2\else #3\fi\fi}
\def\upol@declare@cs{Prohlašuji, že jsem \upol@strin{cs}{typeacc@\upol@type}
  \enquote{\upol@thetitle} \upol@g{vypracoval}{vypracovala}{vypracoval/a}
  samostatně a~\upol@g{uvedl}{uvedla}{uvedl/a} jsem veškerou použitou
  literaturu a~veškeré použité zdroje.}
\def\upol@declare@sk{Vyhlasujem, že som \upol@strin{sk}{typeacc@\upol@type}
  \enquote{\upol@thetitle} \upol@g{vypracoval}{vypracovala}{vypracoval/a}
  samostatne a~\upol@g{uviedol}{uviedla}{uviedol/uviedla} som všetku použitú
  literatúru a~všetky použité zdroje.}
\def\upol@declare@en{I declare that I have written the
  \upol@strin{en}{typeacc@\upol@type} \enquote{\upol@thetitle} on my own and
  that I have listed all the literature and sources I have used.}

% PhD: the wording used in recent KOL dissertations, plus the clause on
% other degrees
\def\upol@declare@cs@phd{Prohlašuji, že jsem disertační práci
  \enquote{\upol@thetitle} \upol@g{vypracoval}{vypracovala}{vypracoval/a}
  samostatně, že jsem řádně \upol@g{citoval}{citovala}{citoval/a} všechny
  použité prameny a~literaturu a~že práce nebyla využita v~rámci jiného
  vysokoškolského studia či k~získání jiného nebo stejného titulu.}
\def\upol@declare@sk@phd{Vyhlasujem, že som dizertačnú prácu
  \enquote{\upol@thetitle} \upol@g{vypracoval}{vypracovala}{vypracoval/a}
  samostatne, že som riadne \upol@g{citoval}{citovala}{citoval/a} všetky
  použité pramene a~literatúru a~že práca nebola využitá v~rámci iného
  vysokoškolského štúdia ani na získanie iného alebo rovnakého titulu.}
\def\upol@declare@en@phd{I declare that the dissertation
  \enquote{\upol@thetitle} is the result of my own independent research,
  that all the sources I have consulted have been properly cited, and that
  the work has not been used in any other university study or to obtain
  another or the same degree.}

%% --------------------------------------------------------------- metadata
%% \title sets the title in the thesis language; \titlecs, \titlesk and
%% \titleen set a specific one (the English title is always required).
\renewcommand\title[1]{\csdef{upol@title@\upol@langcode}{#1}}
\newcommand\titlecs[1]{\csdef{upol@title@cs}{#1}}
\newcommand\titlesk[1]{\csdef{upol@title@sk}{#1}}
\newcommand\titleen[1]{\csdef{upol@title@en}{#1}}
\newcommand\upol@titlein[1]{%
  \ifcsdef{upol@title@#1}{\csuse{upol@title@#1}}
    {\ClassWarning{upolthesis}{No title in language `#1'}\textbf{???}}}
\def\upol@thetitle{\upol@titlein{\upol@langcode}}

\NewDocumentCommand\abstractcs{+m}{\csdef{upol@abs@cs}{#1}}
\NewDocumentCommand\abstractsk{+m}{\csdef{upol@abs@sk}{#1}}
\NewDocumentCommand\abstracten{+m}{\csdef{upol@abs@en}{#1}}
\newcommand\keywordscs[1]{\csdef{upol@kw@cs}{#1}}
\newcommand\keywordssk[1]{\csdef{upol@kw@sk}{#1}}
\newcommand\keywordsen[1]{\csdef{upol@kw@en}{#1}}
\newcommand\supervisor[1]{\def\upol@supervisor{#1}}
\newcommand\consultant[1]{\def\upol@consultant{#1}}
\newcommand\programme[1]{\def\upol@programme{#1}}
% PhD (SZŘ UP čl. 44 odst. 4h and 6)
\NewDocumentCommand\ipstatement{+m}{\def\upol@ipstatement{#1}}
\NewDocumentCommand\contribution{+m}{\def\upol@contribution{#1}}
\newcommand\thesisyear[1]{\def\upol@year{#1}}
\newcommand\submissiondate[1]{\def\upol@date{#1}}
\NewDocumentCommand\acknowledgements{+m}{\def\upol@ack{#1}}
\NewDocumentCommand\aiuse{+m}{\def\upol@aiuse{#1}}
% manual overrides for the automatic counts
\newcommand\charcount[1]{\def\upol@chars{#1}}
\newcommand\numappendices[1]{\def\upol@appcount{#1}}

\def\upol@supervisor{\textbf{???}}
\edef\upol@year{\the\year}

%% ----------------------------------------------------------------- counts
%% Pages: total physical pages (zref-totpages, from the previous run).
%% Characters: written to \jobname.chars by upol-count.sh, which counts the
%% PDF text between the labels upol@textstart and upol@textend (the start
%% of the bibliography or the appendices).  Appendices: chapters after
%% \appendix.
\providecommand\upol@appcount{0}
\def\upol@autochars{0}
\AtBeginDocument{%
  \makeatletter\InputIfFileExists{\jobname.chars}{}{}\makeatother
  \ifcsdef{upol@minchars@\upol@type}{%
    \ifnum\upol@autochars>0
      \ifnum\upol@autochars<\csuse{upol@minchars@\upol@type}\relax
        \ClassWarningNoLine{upolthesis}{The text has \upol@autochars\space
          characters; the minimum is \csuse{upol@minchars@\upol@type}}%
      \fi\fi}{}}
\newif\ifupol@app
\newif\ifupol@ended
% upol@textstart is set by the first chapter heading after the front
% matter; upol@textlast marks the last page of counted text.
\let\upol@startmark\relax
\newcommand\upol@markend{%
  \ifupol@ended\else\zlabel{upol@textlast}\global\upol@endedtrue\fi}
\pretocmd\appendix{\upol@markend\global\upol@apptrue}{}
  {\ClassError{upolthesis}{Could not patch \string\appendix}{}}
\AtEndDocument{%
  \ifupol@app
    \immediate\write\@auxout{\gdef\string\upol@appcount{\the\c@chapter}}%
  \fi
  \upol@markend}
\newcommand\upol@num[1]{%
  \ifx\upol@langcode\upol@tmp@en\num[group-separator={,}]{#1}%
  \else\num[group-separator={\,}]{#1}\fi}
\newcommand\upol@extent[1]{% #1 = language
  \ztotpages~\upol@strin{#1}{a@pages},
  \ifdefined\upol@chars\upol@num{\upol@chars}%
  \else\ifnum\upol@autochars>0 \upol@num{\upol@autochars}\else\textbf{???}\fi\fi
  ~\upol@strin{#1}{a@chars}}

%% ----------------------------------------------------------------- layout
%% Defaults; the department file may change any of these.
\geometry{top=25mm, bottom=25mm, inner=30mm, outer=25mm}
\def\upol@deptspacing{1.3}
\pagestyle{plain}
\titleformat{\chapter}[hang]{\upol@startmark\normalfont\LARGE\bfseries}{\thechapter}{0.8em}{}
\titlespacing*{\chapter}{0pt}{0pt}{1.5\baselineskip}
\titleformat{\section}{\normalfont\Large\bfseries}{\thesection}{0.8em}{}
\titleformat{\subsection}{\normalfont\large\bfseries}{\thesubsection}{0.8em}{}
\setcounter{secnumdepth}{2}
\setcounter{tocdepth}{2}

% the thesis type as printed on the title page
\newcommand\upol@typeline{%
  \ifupol@autoref\upol@str{autoref}\else\upol@str{type@\upol@type}\fi}
% the study programme: \programme, else the department default
\newcommand\upol@theprogramme{%
  \ifdefined\upol@programme\upol@programme\else\upol@str{programmename}\fi}
\newcommand\upol@logo@file{UP_logo_FF_stred_cerna_\ifx\upol@langcode\upol@tmp@en en\else cz\fi.pdf}
\newcommand\upol@logobox{%
  \def\upol@tmp{shield}\ifx\upol@logo\upol@tmp
    % the bare UP shield, cropped from the official FF logo
    \includegraphics[height=35mm,trim=51 142 51 29,clip]{UP_logo_FF_stred_cerna_cz.pdf}\fi
  \def\upol@tmp{faculty}\ifx\upol@logo\upol@tmp
    \includegraphics[height=45mm]{\upol@logo@file}\fi}

%% Front-matter pages.  All pages are numbered from the title page on, but
%% numbers are printed only from the table of contents onwards.
\newcommand\upol@titlepage{% generic; departments normally redefine it
  \begingroup\thispagestyle{empty}\centering
    {\large\upol@str{university}\par\upol@str{faculty}\par
      \upol@str{dept}\par}
    \vfill\upol@logobox\vfill
    {\huge\bfseries\upol@thetitle\par}\bigskip
    {\large\upol@typeline\par}
    \vfill
    \upol@str{author}: \@author\par
    \upol@str{supervisor}: \upol@supervisor\par
    \bigskip Olomouc \upol@year
  \endgroup\clearpage}

\newcommand\upol@declarationpage{%
  \chapter*{\upol@str{declaration}}\thispagestyle{empty}
  \ifcsdef{upol@declare@\upol@langcode @\upol@type}
    {\csuse{upol@declare@\upol@langcode @\upol@type}}
    {\csuse{upol@declare@\upol@langcode}}\par
  \vspace{2\baselineskip}
  \noindent\upol@str{inplace}~\ifdefined\upol@date\upol@date\else
    \makebox[3cm]{\dotfill}\fi
  \hfill\parbox[t]{5cm}{\centering\dotfill\\ \upol@str{signature}}\par
  \upol@declsection{aiuse}{\upol@aiuse}
  \ifx\upol@type\upol@tmp@phd
    \ifdefined\upol@ipstatement\else
      \ClassWarningNoLine{upolthesis}{A dissertation needs an
        \string\ipstatement\space(SZR UP cl. 44.4h)}\fi
    \upol@declsection{ipdecl}{\upol@ipstatement}
  \fi
  \clearpage
  \ifdefined\upol@contribution
    \chapter*{\upol@str{contrib}}\thispagestyle{empty}
    \upol@contribution\par\clearpage
  \fi}
% \upol@declsection{string key}{macro}: print it if the macro is defined
\newcommand\upol@declsection[2]{%
  \ifdefined#2\vspace{3\baselineskip}\section*{\upol@str{#1}}#2\par\fi}

\newcommand\upol@ackpage{%
  \ifdefined\upol@ack
    \chapter*{\upol@str{ack}}\thispagestyle{empty}
    \upol@ack\par\clearpage
  \fi}

\newcommand\upol@field[2]{\par\noindent\textbf{#1:}\space#2\par\medskip}
\newcommand\upol@abstractpage[1]{% #1 = cs | sk | en
  \edef\upol@tmp{\noexpand\begin{otherlanguage}{\csuse{upol@babel@#1}}}%
  \upol@tmp
  \chapter*{\upol@strin{#1}{abstract}}\thispagestyle{empty}
  \upol@field{\upol@strin{#1}{a@title}}{\upol@titlein{#1}}
  \upol@field{\upol@strin{#1}{a@author}}{\@author}
  \upol@field{\upol@strin{#1}{supervisor}}{\upol@supervisor}
  \ifdefined\upol@consultant
    \upol@field{\upol@strin{#1}{consultant}}{\upol@consultant}\fi
  \upol@field{\upol@strin{#1}{a@extent}}{\upol@extent{#1}}
  \upol@field{\upol@strin{#1}{a@app}}{\upol@appcount}
  \par\noindent\textbf{\upol@strin{#1}{abstract}:}\par\nobreak\smallskip\noindent
  \ifcsdef{upol@abs@#1}{\csuse{upol@abs@#1}}
    {\ClassWarning{upolthesis}{No abstract in language `#1'}\textbf{???}}\par
  \medskip
  \upol@field{\upol@strin{#1}{a@keywords}}{\ifcsdef{upol@kw@#1}
    {\csuse{upol@kw@#1}}{\textbf{???}}}
  \end{otherlanguage}
  \clearpage}

%% \makefrontmatter[lof,lot]: title page, declaration, acknowledgements,
%% abstracts, table of contents and, optionally, the lists of figures (lof)
%% and tables (lot).  The character count starts after it.
\def\upol@list@lof{\listoffigures}
\def\upol@list@lot{\listoftables}
\NewDocumentCommand\makefrontmatter{O{}}{%
  \upol@titlepage
  \ifupol@autoref\else
    \upol@declarationpage
    \upol@ackpage
    \upol@abstractpage{\upol@natcode}
    \upol@abstractpage{en}
  \fi
  \tableofcontents
  \renewcommand*\do[1]{\ifcsdef{upol@list@##1}{\csuse{upol@list@##1}}
    {\ClassError{upolthesis}{Unknown list `##1'}{Use lof or lot.}}}%
  \docsvlist{#1}%
  \gdef\upol@startmark{\zlabel{upol@textstart}\global\let\upol@startmark\relax}}

%% Autoreferát (SZŘ UP čl. 44 odst. 7): at the end, a one-page English
%% abstract and, if the dissertation is not in Czech or Slovak, a Czech
%% summary (\abstractcs).  The list of the student's publications is an
%% ordinary chapter.
\newcommand\upol@shortabstract[2]{% #1 = language, #2 = heading key
  \clearpage
  \edef\upol@tmp{\noexpand\begin{otherlanguage}{\csuse{upol@babel@#1}}}%
  \upol@tmp
  \chapter*{\upol@strin{#1}{#2}}
  \noindent\textbf{\upol@titlein{#1}}\par\medskip\noindent
  \ifcsdef{upol@abs@#1}{\csuse{upol@abs@#1}}
    {\ClassWarning{upolthesis}{No abstract in language `#1'}\textbf{???}}\par
  \medskip
  \upol@field{\upol@strin{#1}{a@keywords}}{\ifcsdef{upol@kw@#1}
    {\csuse{upol@kw@#1}}{\textbf{???}}}
  \end{otherlanguage}}
\ifupol@autoref
  \AtEndDocument{%
    \upol@shortabstract{en}{abstract}%
    \ifx\upol@langcode\upol@tmp@en\upol@shortabstract{cs}{summary}\fi}
\fi

%% ----------------------------------------------------------- bibliography
%% \thesisbibfile{refs.bib} in the preamble, \thesisbibliography at the end.
%% Both styles provide \citet / \citep / \citealt / \citeauthor / \citeyear.
\def\upol@tmp{apa}\ifx\upol@bib\upol@tmp
  \RequirePackage[style=apa,natbib=true,backend=biber]{biblatex}
  % biblatex-apa has Czech strings but no Slovak ones
  \DeclareLanguageMapping{slovak}{american-apa}
  \newcommand\thesisbibfile[1]{\addbibresource{#1}}
  \newcommand\thesisbibliography{%
    \upol@markend\printbibliography[title=\upol@str{bibname}]}
\fi
\def\upol@tmp{acl}\ifx\upol@bib\upol@tmp
  \RequirePackage[authoryear,round]{natbib}
  \newcommand\thesisbibfile[1]{\def\upol@bibfile{#1}}
  \newcommand\thesisbibliography{%
    \upol@markend
    \renewcommand\bibname{\upol@str{bibname}}%
    \bibliographystyle{acl_natbib}\bibliography{\upol@bibfile}}
\fi
\def\upol@tmp{none}\ifx\upol@bib\upol@tmp
  \newcommand\thesisbibfile[1]{}
  \newcommand\thesisbibliography{\upol@markend}
\fi

%% ------------------------------------------------------ department preset
\InputIfFileExists{upolthesis-\upol@dept.def}{}
  {\ClassError{upolthesis}{Unknown department `\upol@dept'}
    {There is no file upolthesis-\upol@dept.def.}}
\setstretch{\ifx\upol@spacing\@empty\upol@deptspacing\else\upol@spacing\fi}

\RequirePackage[hidelinks,unicode]{hyperref}
\AtBeginDocument{\hypersetup{pdftitle={\csuse{upol@title@\upol@langcode}}, pdfauthor={\@author}}}

\endinput
