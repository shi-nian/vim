"             chinachess vim
"             version 1.4
"             author  jumping
"             email www.ping@gmail.com
"             ��K  ��k  ��King��
"             ��A  ʿa  ��Advisor��
"             ��B  ��b  ��Bishop��
"             �RN  ��n  ��Knight��
"             ��R  ��r  ��Rook��
"             �hC  ��c  ��Cannoon��
"             ��P  ��p  ��Pawn��

" ��ɫ���� {{{
syn match red '܇\|�R\|�h\|��\|��\|��\|��\|(\|)'
syn match black '��\|��\|��\|ʿ\|��\|��\|��\|\[\|\]'
syn match gray '��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|һ\|��\|��\|��\|��\|+\|-\||\|x\|#\|�v\|�u'
set background=light
highlight black     gui=bold guifg=Black guibg=LightGray
highlight red       gui=bold guifg=Red guibg=LightGray
highlight gray      gui=None guifg=DarkGray guibg=LightGray
highlight Normal    gui=None guifg=Black guibg=LightGray
hi clear MatchParen
highlight MatchParen gui=None guibg=Gray
highlight Cursor    gui=None guifg=LightGray guibg=Blue
"}}}

"��ʼ���� {{{
let g:chessEnging = ""
let s:line = []
call add(s:line,"  ��   ��   ��   ��   ��   ��   ��   ��   �� ")
call add(s:line,"  +---------------------------------------+  ")
"call add(s:line," [��]-[��]-[��]-[ʿ]-[��]-[ʿ]-[��]-[��]-[��]")
call add(s:line,"  |    |    |    | �v | �u |    |    |    |  ")
call add(s:line,"  |----+----+----+----x----+----+----+----|  ")
call add(s:line,"  |    |    |    | �u | �v |    |    |    |  ")
call add(s:line,"  |----#----+----+----+----+----+----#----|  ")
"call add(s:line,"  |---[��]--+----+----+----+----+---[��]--|  ")
call add(s:line,"  |    |    |    |    |    |    |    |    |  ")
call add(s:line,"  |----+----#----+----#----+----#----+----|  ")
"call add(s:line," [��]--+---[��]--+---[��]--+---[��]--+---[��]")
call add(s:line,"  |    |    |    |    |    |    |    |    |  ")
call add(s:line,"  |---------------------------------------|  ")
call add(s:line,"  |       �� ��               �� ��       |  ")
call add(s:line,"  |---------------------------------------|  ")
call add(s:line,"  |    |    |    |    |    |    |    |    |  ")
call add(s:line,"  |----+----#----+----#----+----#----+----|  ")
"call add(s:line," (��)--+---(��)--+---(��)--+---(��)--+---(��)")
call add(s:line,"  |    |    |    |    |    |    |    |    |  ")
call add(s:line,"  |----#----+----+----+----+----+----#----|  ")
"call add(s:line,"  |---(�h)--+----+----+----+----+---(�h)--|  ")
call add(s:line,"  |    |    |    | �v | �u |    |    |    |  ")
call add(s:line,"  |----+----+----+----x----+----+----+----|  ")
call add(s:line,"  |    |    |    | �u | �v |    |    |    |  ")
call add(s:line,"  +---------------------------------------+  ")
"call add(s:line," (܇)-(�R)-(��)-(��)-(��)-(��)-(��)-(�R)-(܇)")
call add(s:line,"  ��   ��   ��   ��   ��   ��   ��   ��   һ ")

let s:actionP = "ƽ"
let s:actionJ = "��"
let s:actionT = "��"
let s:postionQ = "ǰ"
let s:postionH = "��"

let s:redChessK = "��" 
let s:redChessA = "��" 
let s:redChessB = "��" 
let s:redChessN = "�R" 
let s:redChessR = "܇" 
let s:redChessC = "�h" 
let s:redChessP = "��" 

let s:blackChessK = "��" 
let s:blackChessA = "ʿ" 
let s:blackChessB = "��" 
let s:blackChessN = "��" 
let s:blackChessR = "��" 
let s:blackChessC = "��" 
let s:blackChessP = "��" 
let s:curChessInfo=[0,0,'']

let b:parseFlag = 0
let b:chessStep = []
let b:chessCom = {} 
let b:step = 0
let b:result = "��"
let b:FEN = ""
let b:Red = ""
let b:Black = ""
let b:Opening = ""
"}}}

"ParseChessFile {{{
function s:ParseChessFile()
    if b:parseFlag 
        echo "had parsed!" 
        return 
    endif
    let b:parseFlag = 1
    normal gg
    let step = 1
    let curCol = line(".") 
    let curLine = getline(".")
    let rxChessMove = '\(˧\|܇\|�R\|�h\|��\|��\|��\|��\|��\|��\|��\|ʿ\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|һ\|ƽ\|��\|��\|ǰ\|��\)\{4\}'  
    let rxKeyLine = '^\s*\[.*\]'
    let rxComLine = '^\s*{\|^\s*('
    let lastLine = line("$")
    while curCol <= lastLine
        " result line
        if curLine =~ '^\s*\d-\d'
            if curLine =~ "^\s*1-0"
                let b:result = "��ʤ"
            else
                if curLine =~ "^\s*0-1"
                    let b:result = "��ʤ"
                else
                    if curLine =~ "^\s*1-1"
                        let b:result = "�;�"
                    else
                        let b:result = "δ֪"
                    endif
                endif
            endif
        endif

        " key line
        if curLine =~ rxKeyLine
            if curLine =~ '^\s*[\s*FEN'
                let b:FEN = substitute(curLine, '.*"\(.*\)".*', '\1', "")
            endif

            if curLine =~ '^\s*[\s*Red'
                let b:Red = substitute(curLine, '.*"\(.*\)".*', '\1', "")
            endif
            if curLine =~ '^\s*[\s*Opening'
                let b:Opening = substitute(curLine, '.*"\(.*\)".*', '\1', "")
            endif

            if curLine =~ '^\s*[\s*Black'
                let b:Black = substitute(curLine, '.*"\(.*\)".*', '\1', "")
            endif

            if curLine =~ '^\s*[\s*Result'
                let b:result = substitute(curLine, '.*"\(.*\)".*', '\1', "")

                if b:result == "1-0"
                    let b:result = "��ʤ"
                else
                    if b:result == "0-1"
                        let b:result = "��ʤ"
                    else
                        if curLine == "1-1"
                            let b:result = "�;�"
                        else
                            let b:result = "δ֪"
                        endif
                    endif
                endif
                
            endif
            let curCol = line(".")
            normal j
            let curLine = getline(".")
            let curCol += 1
            continue
        endif

        " comment line
        if curLine =~ rxComLine
            if curLine =~ '^\s*{'
                call searchpair('{','','}')
            else
                call searchpair('(','',')')
            endif
            normal v%l"ay
            let b:chessCom[step-1] = @a
            let curCol = line(".")
"            call add(b:chessCom,@a)
            normal j
            let curLine = getline(".")
            let curCol += 1
            continue
        endif

        " space line
        if curLine =~ '^\s*$'
            let temp = line(".")
            let curCol = line(".")
            normal j
            let curLine = getline(".")
            let curCol += 1
            continue
        endif

       let posCol =match(curLine,rxChessMove, 0)  
       while posCol >= 0
           let curChess =  strpart(curLine, posCol, 8)
           if step%2 == 1
               if curChess =~ '��'
                   let curChess = substitute(curChess,'��','�h',"")
               endif
               if curChess =~ '��'
                   let curChess = substitute(curChess,'��','�R',"")
               endif
               if curChess =~ '��'
                   let curChess = substitute(curChess,'��','܇',"")
               endif
               if curChess =~ 'ʿ'
                   let curChess = substitute(curChess,'ʿ','��',"")
               endif
               if curChess =~ '˧'
                   let curChess = substitute(curChess,'˧','��',"")
               endif
           endif
           call add(b:chessStep, curChess)
           let step += 1
           "һ���غ�����ע��
           if strpart(curLine,posCol +8) =~ rxComLine
               let preCol = line(".")
               if strpart(curLine,posCol +8) =~ '^\s*{'
                   normal f{%
               else
                   normal f(%
               endif
               normal v%l"*y
               normal h%
               let b:chessCom[step-1] = @*
               let curCol = line(".")

               if curCol != preCol
                   let curLine = getline(".")
               endif
               let posCol =match(curLine,rxChessMove,col("."))   
           else
               let posCol =match(curLine,rxChessMove,posCol +8)   
           endif
       endwhile

       let temp = line(".")
       normal j
       let curLine = getline(".")
       let curCol += 1
    endwhile        
endfunction
"}}}

"ClearChess {{{
function s:ClearChess(line,col)
    
    call setpos('.',[0,a:line,a:col-1,0])
    "�����ǰ����
    if a:line == 20 || a:line == 2          
        "��һ�� �� ���һ��
        if a:col == 3
            exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/ +--' 
        else
            if a:col == 43
                exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/-+  ' 
            else
                exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/----' 
            endif
        endif

    else

        if a:line == 10 || a:line == 12
        "���Աߵ�����
            if a:col == 3
                exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/ |--' 
            else
                if a:col == 43
                    exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/-|  ' 
                else
                    exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/----' 
                endif
            endif

        else
            if (a:line == 4 || a:line == 18 )&& a:col ==23
                exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/-x--' 
            else
                if ((a:line == 6 || a:line == 16) && (a:col == 8 || a:col == 38))||((a:line == 8 || a:line == 14) && (a:col == 13 || a:col == 23 || a:col == 33))
                    exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/-#--' 
                else

                    " ��������
                    if a:col == 3 
                        exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/ |--' 
                    else
                        if a:col == 43
                            exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/-|  ' 
                        else
                            exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/-+--' 
                        endif
                    endif
                endif
            endif

        endif
    endif
endfunction
"}}}

"ChinaChess2DigitalChess {{{
function s:ChinaChess2DigitalChess(chess)
    if a:chess ==  s:blackChessR
        let chess ='r'
    endif
    if a:chess ==  s:blackChessN
        let chess ='n'
    endif
    if a:chess ==  s:blackChessB
        let chess ='b'
    endif
    if a:chess ==  s:blackChessA
        let chess ='a'
    endif
    if a:chess ==  s:blackChessK
        let chess ='k'
    endif
    if a:chess ==  s:blackChessC
        let chess ='c'
    endif
    if a:chess ==  s:blackChessP
        let chess ='p'
    endif
    if a:chess ==  s:redChessR
        let chess ='R'
    endif
    if a:chess ==  s:redChessN
        let chess ='N'
    endif
    if a:chess ==  s:redChessB
        let chess ='B'
    endif
    if a:chess ==  s:redChessA
        let chess ='A'
    endif
    if a:chess ==  s:redChessK
        let chess ='K'
    endif
    if a:chess ==  s:redChessC
        let chess ='C'
    endif
    if a:chess ==  s:redChessP
        let chess ='P'
    endif
    return chess
endfunction
"}}}

"DigitalChess2ChinaChess {{{
"���ֱ�ʾ����-�����ı�ʾ����
function s:DigitalChess2ChinaChess(chess)
    if a:chess == 'r'
        let chess = s:blackChessR
    endif
    if a:chess == 'n'
        let chess = s:blackChessN
    endif
    if a:chess == 'b'
        let chess = s:blackChessB
    endif
    if a:chess == 'a'
        let chess = s:blackChessA
    endif
    if a:chess == 'k'
        let chess = s:blackChessK
    endif
    if a:chess == 'c'
        let chess = s:blackChessC
    endif
    if a:chess == 'p'
        let chess = s:blackChessP
    endif
    if a:chess == 'R'
        let chess = s:redChessR
    endif
    if a:chess == 'N'
        let chess = s:redChessN
    endif
    if a:chess == 'B'
        let chess = s:redChessB
    endif
    if a:chess == 'A'
        let chess = s:redChessA
    endif
    if a:chess == 'K'
        let chess = s:redChessK
    endif
    if a:chess == 'C'
        let chess = s:redChessC
    endif
    if a:chess == 'P'
        let chess = s:redChessP
    endif
    return chess
endfunction

"}}}

"DrawChessOnBoard {{{
function s:DrawChessOnBoard(chess,line,col)
    
    let chess = a:chess
    if a:chess =~ 'r\|n\|b\|a\|k\|c\|p\|R\|N\|B\|A\|K\|C\|P'
        let chess = s:DigitalChess2ChinaChess(a:chess)
    endif
    if chess =~ '܇\|�R\|�h\|��\|��\|��\|��'
        let chess = '('.chess.')'
    else
        let chess = '['.chess.']'
    endif
    call setpos('.',[0,a:line,1,0])
    exe ':substitute/\%'.(a:col-1).'c.*\%'.(a:col+3).'c/'.chess 
    "let s:line[a:line*2+1] = substitute(s:line[a:line*2+1],"\\%".(a:col*5+2)."c.*\\%".(a:col*5+6)."c", chess,"")

endfunction 
"}}}

"LoadFen {{{
function s:LoadFen(FEN)
    if a:FEN != ""
        let i=0
        let col = 0
        let line = 0
        while i < strlen(a:FEN)
            if a:FEN[i] == '/'
                let line += 1
                let col = 0
                let i += 1
                continue
            else
                if a:FEN[i] == ' '
                    break
                endif

                if a:FEN[i] <= '9' && a:FEN[i] >= '1'
                    let col += a:FEN[i]
                    let i += 1
                    continue
                endif
                
            endif
            call s:DrawChessOnBoard(a:FEN[i],line*2+2,col*5+3)
            let col += 1
            let i += 1
        endwhile
    endif
endfunction
"}}}

"DrawChessboard {{{
function s:DrawChessboard()
    if b:result != "��"
        echo "�����Ѿ�������"
        return 
    endif
    let b:parseFlag = 0
    call s:ParseChessFile()
    set lines=22
    set columns=45
    normal ggVGd

    for s:item in s:line 
        exec "normal o".s:item
    endfor
    normal ggdd

    if b:FEN == ""
        let b:FEN = 'rnbakabnr/9/1c5c1/p1p1p1p1p/9/9/P1P1P1P1P/1C5C1/9/RNBAKABNR'
    endif

    call s:LoadFen(b:FEN)


    let &title=1
    if b:Red == ""
        let &titlestring=" ".b:Opening." ����:".b:result
    else
        let &titlestring="�췽:".b:Red." �ڷ�:".b:Black." ����:".b:result
    endif
    normal gg

endfunction
"}}}

"DrawNext {{{
function s:DrawNext()
    if len(b:chessStep) == 0
        echo "û����"
        return
    endif
    if b:step >= len(b:chessStep)
        echo b:result
        return
    else 
        echo b:chessStep[b:step]
    endif
    call s:MoveChess(b:chessStep[b:step])
    let b:step +=1
    if has_key(b:chessCom, b:step)
        call confirm(b:chessCom[b:step])
    endif
endfunction
"}}}

"MoveChessDigital {{{
" �����Ǹ�ʽ������������ĸ�����ִ��溺�֣����С����������ˡ��͡�ƽ���ֱ��÷��š�+������-���͡�.����ʾ����ǰ�������С��͡���Ҳ�ֱ��÷��š�+������-���͡�.����ʾ������д�����ӵĺ���(���硰ǰ���˶���д�ɡ�C+-2�������ǡ�+C-2��)�������λ��һ������ʱ�����桰ǰ�к󡱵ġ�һ�������塱�ֱ��á�abcde����ʾ��
function s:MoveChessDigital(chessStep)
    let cChessStep = ""
    let cChessStep = s:DigitalChess2ChinaChess(a:chessStep[0])
    if cChessStep =~ '܇\|�R\|�h\|��\|��\|��\|��'
        let chessPosition = 'һ�����������߰˾�'
    else
        let chessPosition = '������������������'
    endif
    if a:chessStep[1] =~ '\d'
        let cChessStep .= strpart(chessPosition,(a:chessStep[1]-1)*2,2)
    else
        if a:chessStep[1] == '+'
            let cChessStep = s:postionQ.cChessStep
        else
            if a:chessStep[1] == '-'
                let cChessStep = s:postionH.cChessStep
            else
                "û����abcde
                let cChessStep .= '��'.cChessStep
            endif
        endif

    endif

    if a:chessStep[2] == '+'
        let cChessStep .= s:actionJ
    else
        if a:chessStep[2] == '-'
            let cChessStep .= s:actionT
        else
            let cChessStep .= s:actionP
        endif
    endif

    let cChessStep .= strpart(chessPosition,(a:chessStep[3]-1)*2,2)

    echo cChessStep
    call s:MoveChess(cChessStep)
"    return cChessStep

endfunction
"}}}

"GetCurPos {{{
function s:GetCurPos(curChess, curStep, action)
    normal gg
    let [lnum, col] = searchpos(a:curChess,'n')
    if lnum == 0 && col == 0
"        echo b:result
        return [lnum,col]
    endif


    let [lnum1, s:col1] = searchpos(a:curStep,'n')
    if lnum1 ==0 && s:col1 ==0
        " curStep �� ǰ ���� �� �����Ӷ�λ 
        if a:curStep == s:postionQ && b:step%2 !=0
            call setpos('.',[0,lnum,col,0])
            let [lnum, col] = searchpos(a:curChess,'n')
        endif
        if a:curStep == s:postionH && b:step%2 ==0
            call setpos('.',[0,lnum,col,0])
            let [lnum, col] = searchpos(a:curChess,'n')
        endif
        let s:col1 = col "�ҵ���ǰ����
    else
        if a:curChess =~ '��\|��' 
            "red chess
            "��������˲��ܽ� ������������������
            if lnum == 16 &&  a:action == s:actionJ && a:curChess == s:redChessA
                call setpos('.',[0,lnum,col,0])
                let [lnum, col] = searchpos(a:curChess,'n')
            endif
            "��������಻�ܽ� ������������������
            if lnum == 12 &&  a:action == s:actionJ && a:curChess == s:redChessB
                call setpos('.',[0,lnum,col,0])
                let [lnum, col] = searchpos(a:curChess,'n')
            endif
        endif
        if a:curChess =~ 'ʿ\|��' 
            "black chess
            " ���壬��һ�У��������ˣ�����������������
            if lnum == 2 && a:action == s:actionT
                call setpos('.',[0,lnum,col,0])
                let [lnum, col] = searchpos(a:curChess,'n')
            endif
        endif

    endif

    let searchCount = 1
    while s:col1 != col 
        if searchCount == 5
"            echo "���״���"
            return [0,0]
        endif
        call setpos('.',[0,lnum,col,0])
        let [lnum, col] = searchpos(a:curChess,'n')
        let searchCount += 1
    endwhile
    return [lnum,col]
endfunction
"}}}

"MoveChess {{{
function s:MoveChess(chessStep)
    let s:curChess = strpart(a:chessStep,0,2)
    let s:curStep =strpart(a:chessStep,2,2)
    "if stridx(s:line[0],s:curStep) == -1 && stridx(s:line[20],s:curStep) == -1 
    if  s:curStep !~ '��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|��\|һ'
        let s:curChess = s:curStep
        let s:curStep = strpart(a:chessStep,0,2)
    endif 
    let s:action = strpart(a:chessStep,4,2)
    let s:nextStep = strpart(a:chessStep,6,2)
    "�õ���ǰ����λ��   
    let [s:lnum,s:col] = s:GetCurPos(s:curChess, s:curStep, s:action)

    if s:lnum == 0 && s:col == 0
        echo "���״���"
        return 
    endif

    call s:ClearChess(s:lnum,s:col) 

    normal gg
    let s:pos = s:GetNextPos(s:curChess,s:action,s:nextStep)
    call setpos('.',s:pos)

    " ���ƶ��������
"    normal h
    call s:DrawChessOnBoard(s:curChess,s:pos[1],s:pos[2])
"    if b:step%2 ==0
"        let curLine = getline('.')
"        exe ':substitute/\%'.(s:pos[2]-1).'c.*\%'.(s:pos[2]+3).'c/('.s:curChess.')' 
"    else
"        exe ':substitute/\%'.(s:pos[2]-1).'c.*\%'.(s:pos[2]+3).'c/['.s:curChess.']' 
"    endif
    call setpos('.',s:pos)
    "normal h

endfunction
"}}}

" GetNextPos {{{
function s:GetNextPos(chess,action,next)
    let [s:lnum2,s:col2] = searchpos(a:next,'n')
    let ret = [0,s:lnum,s:col,0]
    "�� ��
    if a:chess == s:redChessK || a:chess == s:redChessP
         if a:action == s:actionJ
             let ret[1] -= 2
         endif
         if a:action == s:actionT
             let ret[1] += 2
         endif
         if a:action == s:actionP
             let ret[2] = s:col2
         endif
    endif
    "black
    if a:chess == s:blackChessK || a:chess == s:blackChessP
         if a:action == s:actionJ
             let ret[1] += 2
         endif
         if a:action == s:actionT
             let ret[1] -= 2
         endif
         if a:action == s:actionP
             let ret[2] = s:col2
         endif
    endif

    "��
    if a:chess == s:redChessA
        let ret[2] = s:col2
         if a:action == s:actionJ
             let ret[1] -= 2 
         endif
         if a:action == s:actionT
             let ret[1] += 2
         endif
    endif
    "black
    if a:chess == s:blackChessA
        let ret[2] = s:col2
         if a:action == s:actionJ
             let ret[1] += 2 
         endif
         if a:action == s:actionT
             let ret[1] -= 2
         endif
    endif

    "��
    if a:chess == s:redChessB
        let ret[2] = s:col2
         if a:action == s:actionJ
             let ret[1] -= 4 
         endif
         if a:action == s:actionT
             let ret[1] += 4
         endif
    endif
    "black
    if a:chess == s:blackChessB
        let ret[2] = s:col2
         if a:action == s:actionJ
             let ret[1] += 4 
         endif
         if a:action == s:actionT
             let ret[1] -= 4
         endif
    endif

    "�R
    if a:chess == s:redChessN
        let ret[2] = s:col2
         if a:action == s:actionJ
             if abs(s:col1-s:col2) == 10
                 let ret[1] -= 2
             else
                 let ret[1] -= 4
             endif 
         endif
         if a:action == s:actionT
             if abs(s:col1-s:col2) == 10
                 let ret[1] += 2
             else
                 let ret[1] += 4
             endif 
         endif
    endif
    "black
    if a:chess == s:blackChessN
        let ret[2] = s:col2
         if a:action == s:actionJ
             if abs(s:col1-s:col2) == 10
                 let ret[1] += 2
             else
                 let ret[1] += 4
             endif 
         endif
         if a:action == s:actionT
             if abs(s:col1-s:col2) == 10
                 let ret[1] -= 2
             else
                 let ret[1] -= 4
             endif 
         endif
    endif

    "܇ �h
    if a:chess == s:redChessR || a:chess == s:redChessC
         if a:next == 'һ' 
             let offset = 2
         endif
         if a:next == '��' 
             let offset = 4
         endif
         if a:next == '��' 
             let offset = 6
         endif
         if a:next == '��' 
             let offset = 8
         endif
         if a:next == '��' 
             let offset = 10
         endif
         if a:next == '��' 
             let offset = 12
         endif
         if a:next == '��' 
             let offset = 14
         endif
         if a:next == '��' 
             let offset = 16
         endif
         if a:next == '��' 
             let offset = 18
         endif
         if a:action == s:actionJ
             let ret[1] -= offset 
         endif
         if a:action == s:actionT
             let ret[1] += offset
         endif
         if a:action == s:actionP
             let ret[2] = s:col2
         endif
    endif
    "black
    if a:chess == s:blackChessR || a:chess == s:blackChessC
         if a:next == '��' 
             let offset = 2
         endif
         if a:next == '��' 
             let offset = 4
         endif
         if a:next == '��' 
             let offset = 6
         endif
         if a:next == '��' 
             let offset = 8
         endif
         if a:next == '��' 
             let offset = 10
         endif
         if a:next == '��' 
             let offset = 12
         endif
         if a:next == '��' 
             let offset = 14
         endif
         if a:next == '��' 
             let offset = 16
         endif
         if a:next == '��' 
             let offset = 18
         endif
         if a:action == s:actionJ
             let ret[1] += offset 
         endif
         if a:action == s:actionT
             let ret[1] -= offset
         endif
         if a:action == s:actionP
             let ret[2] = s:col2
         endif
    endif
    return ret
endfunction
"}}}

"DrawPreview  {{{
function s:DrawPreview()
    if b:step > 0
        let b:step -= 1
        normal u
    else
        echo "û��һ����"
    endif
endfunction
"}}}

"GetCurChess {{{
function s:GetCurChess()
    let [temp1,s:curChessInfo[0],s:curChessInfo[1],temp2] = getpos(".")
    let s:curChessInfo[2] = strpart(getline("."),s:curChessInfo[1]-2,4)
    echo s:curChessInfo
endfunction
"}}}

"MoveCurChess {{{
function s:MoveCurChess()
    let temp = getpos(".")
    call s:ClearChess(s:curChessInfo[0],s:curChessInfo[1])

    call setpos('.',temp)
    exe ':substitute/\%'.(temp[2]-1).'c.*\%'.(temp[2]+3).'c/'.s:curChessInfo[2]
    call setpos('.',temp)
endfunction
"}}}

"CursorMove {{{
function s:CursorMove(dir)
    let temp = getpos(".")
    if a:dir == "up"
        let temp[1] -= 2
    endif
    if a:dir == "down"
        let temp[1] += 2
    endif
    if a:dir == "left"
        let temp[2] -= 5
    endif
    if a:dir == "right"
        let temp[2] += 5
    endif
    let temp[1] = (temp[1]-2)/2*2 +2
    let temp[2] = (temp[2]-3)/5*5 +3
    if temp[1]<2
        let temp[1] = 2
    endif
    if temp[1]>20
        let temp[1] = 20
    endif
    if temp[2] <3
        let temp[2] =3
    endif
    if temp[2] >43
        let temp[2] =43
    endif
    call setpos(".",temp)

endfunction
"}}}

"GetCurFen {{{
func! GetCurFen(color,...)
    let fen = ""
    let i=2
    let rxChess = '˧\|܇\|�R\|�h\|��\|��\|��\|��\|��\|��\|��\|ʿ\|��\|��\|��' 
    while i< 22
        let j=3
        let blankCount = 0
        while j < 48
            let curC = strpart(getline(i),j-1,2)

            if curC =~ rxChess
                if blankCount != 0
                    let fen .= blankCount
                endif
                let fen .= s:ChinaChess2DigitalChess(curC)
                let blankCount = 0
            else
                let blankCount += 1
                if j == 43
                    let fen .= blankCount
                endif
            endif

            let j+= 5
        endwhile

        if i < 20
            let fen .= '/'
        endif

        let i += 2
    endwhile

    "if exists(a:2)
    if a:0 == 1
        let step = a:1
    else
        let step = 0
    endif

    let fen .=' '.a:color.' - - 0 '.step
    "echo fen
    return fen

endfunction
"}}}

"SetCurPosition {{{
function s:SetCurPosition(pos)
    let x=a:pos[0]
    let y=a:pos[1]
    let x=(char2nr(x)-char2nr('a'))*5+3
    let y=(9-(y-'0'))*2+2
    call setpos('.',[0,y,x,0])
endfunction
"}}}

"ComputeMove {{{
function! ComputeMove(col)
    let engineInput = "ucci\nposition fen ".GetCurFen(a:col)."\ngo depth 20\nquit"
    redir! > temp
    silent echo engineInput
    redir END

    if g:chessEnging != ""
        let result = system(g:chessEnging.'<temp')
    else
        let result = system('chess-ucci.exe<temp')
    endif
    let roffset = match(result,"bestmove",0)
    if roffset != -1
        let movechess = strpart(result,roffset+9,4)
        "echo movechess
    else
        echo "no result"
        return
    end
    call s:SetCurPosition(strpart(movechess,0,2))
    let [temp1,s:curChessInfo[0],s:curChessInfo[1],temp2] = getpos(".")
    let s:curChessInfo[2] = strpart(getline("."),s:curChessInfo[1]-2,4)
    call s:SetCurPosition(strpart(movechess,2,2))
    call s:MoveCurChess()
    "call system("del /F /Q temp")
    "echo result
endfunction
"}}}

"key map {{{
"computer run red chess
nmap <silent><F2>       : call ComputeMove('w')<CR>
"computer run black chess
nmap <silent><F4>       : call ComputeMove('b')<CR>
nmap <silent><A-n>      : call <SID>DrawNext()<CR>
nmap <silent><PageDown> : call <SID>DrawNext()<CR>
nmap <silent><A-d>      : call <SID>DrawChessboard()<CR>
nmap <silent><Home>     : call <SID>DrawChessboard()<CR>
nmap <silent><A-p>      : call <SID>DrawPreview()<CR>
nmap <silent><PageUp>   : call <SID>DrawPreview()<CR>
nmap <silent><A-q>      : q!<CR>
nmap <silent><End>      : q!<CR>
nmap <silent><SPACE>    : call  <SID>GetCurChess()<CR>
nmap <silent><CR>       : call <SID>MoveCurChess()<CR>
nmap <silent><up>       : call <SID>CursorMove("up")<CR>
nmap <silent><down>     : call <SID>CursorMove("down")<CR>
nmap <silent><left>     : call <SID>CursorMove("left")<CR>
nmap <silent><right>    : call <SID>CursorMove("right")<CR>
command! -nargs=+ Move call <SID>MoveChessDigital(<f-args>)
"}}}

function! Dest()
    call s:ParseChessFile()
endfunction
" vim: fdm=marker 
