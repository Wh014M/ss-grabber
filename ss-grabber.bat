:: Programmed by hXR16F
:: hXR16F.ar@gmail.com, https://github.com/hXR16F

@echo off
setlocal EnableDelayedExpansion

if defined __ goto :variables
set __=.
darkbox | call %0 %* | darkbox
set __=
pause >nul
goto :eof

:variables
	mode 87,24
	echo -h 0
	color 0f
	@chcp 65001 >nul

	if %time:~9,1% lss 3 (set "main_color=0x0c") else if %time:~9,1% lss 6 (set "main_color=0x0a") else if %time:~9,1% lss 9 (set "main_color=0x09") else (set "main_color=0x09")
	call :logo

	if exist "raw.tmp" del /f /q "raw.tmp" >nul

	(
		set "charset=qwertyuiopasdfghjklzxcvbnm1234567890"
		set "ua=Mozilla/5.0 ^(Macintosh; Intel Mac OS X 10_11_6^) AppleWebKit/537.36 ^(KHTML, like Gecko^) Chrome/70.0.3538.102 Safari/537.36"

		for /f "tokens=2 delims= " %%i in (
			'mode con ^| findstr /i /c:"Columns"'
		) do set /a columns=%%i - 10
		for /l %%i in (1,1,!columns!) do set "line_reset=!line_reset! "

		set total_downloaded=0
		set total_fetched=0
		set total_files=0
	)

	if exist "screenshots" (
		pushD screenshots && for /f "tokens=1 delims=." %%i in ('dir /b /od') do (
			set /a total_files+=1
			set last_file=%%i
		) && popD
		set /a last_file+=1
	) else (
		set last_file=1
		md "screenshots"
	)

	set /a fetching=!ypos!+1
	set /a downloading=!ypos!+2
	set /a total=!ypos!+3
	set /a author=!ypos!+5

	echo -g 5 !author! -c 0x0f -d "▒" -c 0x08 -d " Made with " -c %main_color% -d "♥" -c 0x08 -d " by " -c 0x0f -d "hXR16F" -r

	goto :main

:main
	set "link="
	call :random_url

	echo -g 5 !fetching! -d "%line_reset%"^
	     -g 5 !fetching! -c 0x0f -d "▒" -c %main_color% -d " Fetching: "^
		 -c 0x0f -d "!url!"
		 
	curl -H "User-Agent: %ua%" -ss https://prnt.sc/!url! --ssl-no-revoke -o raw.tmp
	for /f %%i in ("raw.tmp") do echo -g 24 !fetching! -c %main_color% -d "[" -c 0x08 -d "%%~zi bytes" -c %main_color% "]"

	for /f "tokens=13,15 delims=>" %%a in ('find "no-click screenshot-image" raw.tmp') do (
		for /f "tokens=3 delims==" %%i in ("%%a") do (
			for /f "tokens=1 delims= " %%z in ("%%i") do (
				set "link=%%~z"
				set "file=%%~nxz"
				echo !link! | findstr /c:image.prntscr.com >nul && (
					for /f "tokens=4 delims=/" %%x in ("!link!") do (
						curl -H "User-Agent: %ua%" -ss !link! --ssl-no-revoke -o screenshots/!last_file!.png
						set /a total_downloaded+=1
						set /a total_files+=1
						pushD screenshots && for /f %%n in ("!last_file!.png") do (
							set /a size=%%~zn / 1024
							echo -g 5 !downloading! -d "%line_reset%"^
							     -g 5 !downloading! -c 0x0f -d "▒" -c %main_color% -d " Last download: "^
								 -c 0x0f -d "!file! "^
								 -c %main_color% -d "as "^
								 -c 0x0f -d "!last_file!.png "^
								 -c %main_color% -d "[" -c 0x08 -d "!size! kB" -c %main_color% "]"
						) && popD
						set /a last_file+=1
					)
				)
			)
		)
	)

	set /a total_fetched+=1
	echo -g 5 !total! -d "%line_reset%"^
	     -g 5 !total! -c 0x0f -d "▒" -c %main_color% -d " Total: "^
		 -c 0x0f -d "!total_downloaded!" -c 0x08 -d " / " -c 0x0f -d "!total_fetched!" -c 0x08 -d " / " -c 0x0f -d "!total_files! "^
		 -c %main_color% -d "[" -c 0x08 -d "downloaded" -c 0x0f -d "," -c 0x08 -d " fetched" -c 0x0f -d "," -c 0x08 -d " total in folder" -c %main_color% "]"

	goto :main

:random_url
	set random_loop=0
	set "url="

	:random_url_loop
		if !random_loop! equ 6 (goto :eof) else (
			set /a rand=%random% * 35 / 32768 + 1
			set "url=!url!!charset:~%rand%,1!"
			set /a random_loop+=1
			goto :random_url_loop
		)
	)

	goto :eof

:logo
	set ypos=3
	echo -c %main_color%
	for %%i in (
		"  ██████   ██████  "
		"▒██    ▒ ▒██    ▒  "
		"░ ▓██▄   ░ ▓██▄   ▒"
		"  ▒   ██▒  ▒   ██▒░"
		"▒██████▒▒▒██████▒▒░"
		"▒ ▒▓▒ ▒ ░▒ ▒▓▒ ▒ ░ "
		"░ ░▒  ░ ░░ ░▒  ░ ░ "
		"░  ░  ░  ░  ░  ░  ░"
		"      ░        ░   "
	) do (
		echo -g 5 !ypos! -d "%%~i" -n
		set /a ypos+=1
	)

	set ypos=3
	echo -c 0x0f
	for %%i in (
		" ▄████  ██▀███   ▄▄▄       ▄▄▄▄    ▄▄▄▄   ▓█████  ██▀███  "
		"██▒ ▀█▒▓██ ▒ ██▒▒████▄    ▓█████▄ ▓█████▄ ▓█   ▀ ▓██ ▒ ██▒"
		"██░▄▄▄░▓██ ░▄█ ▒▒██  ▀█▄  ▒██▒ ▄██▒██▒ ▄██▒███   ▓██ ░▄█ ▒"
		"▓█  ██▓▒██▀▀█▄  ░██▄▄▄▄██ ▒██░█▀  ▒██░█▀  ▒▓█  ▄ ▒██▀▀█▄  "
		"▒▓███▀▒░██▓ ▒██▒ ▓█   ▓██▒░▓█  ▀█▓░▓█  ▀█▓░▒████▒░██▓ ▒██▒"
		"░▒   ▒ ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░▒▓███▀▒░▒▓███▀▒░░ ▒░ ░░ ▒▓ ░▒▓░"
		" ░   ░   ░▒ ░ ▒░  ▒   ▒▒ ░▒░▒   ░ ▒░▒   ░  ░ ░  ░  ░▒ ░ ▒░"
		" ░   ░   ░░   ░   ░   ▒    ░    ░  ░    ░    ░     ░░   ░ "
		"     ░    ░           ░  ░ ░       ░         ░  ░   ░     "
		"                                ░       ░                 "
	) do (
		echo -g 24 !ypos! -d "%%~i" -n
		set /a ypos+=1
	)

	echo -r
	set /a ypos+=1
	
	goto :eof
