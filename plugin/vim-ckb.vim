" Color variables
let s:Normal_Color = "00ff00"
let s:Insert_Color = "ff8000"
let s:Replace_Color = "ff00ff"
let s:Visual_Color = "0000ff"

let s:Navigation_Color = "ffffff"
"

if exists("g:loaded_ckbvim")
	finish
endif
let g:loaded_ckbvim = 1

let s:LastUpdatedMode = ""

function! s:CKBCmd(cmd)
	call writefile([a:cmd, ""],"/dev/input/ckb1/cmd")
endfunction

function! s:CKBRefresh(id)
	if s:LastUpdatedMode == mode()
		return
	endif
	let s:LastUpdatedMode = mode()

	if mode() == "n" " Normal mode
		call s:CKBCmd("rgb " . s:Normal_Color)
	elseif mode() == "i" " Insert mode
		call s:CKBCmd("rgb " . s:Insert_Color)
	elseif mode() == "R" || mode() == "Rv" " Replace mode
		call s:CKBCmd("rgb " . s:Replace_Color)
	elseif mode() == "v" || mode() == "V" || mode() == "" " Visual
		call s:CKBCmd("rgb 0000ff" . s:Visual_Color)
	endif

	if mode() == "n" || mode() == "v" || mode() == "V" || mode() == ""
		call s:CKBCmd("rgb h,j,k,l,up,down,left,right:" . s:Navigation_Color)
	elseif mode() == "i" || mode() == "R" || mode() == "Rv"
		call s:CKBCmd("rgb up,down,left,right:" . s:Navigation_Color)
	endif
endfunction

call timer_start(100, function("s:CKBRefresh"), {"repeat": -1})
autocmd InsertEnter,InsertChange,InsertLeave * call s:CKBRefresh(0)

