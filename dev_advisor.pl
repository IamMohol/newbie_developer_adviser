% Languages
language(js).
language(html5).
language(css3).
language('C++').
language('C#').
language(swift).
language(kotlin).
language(python).
language(js).
language(java).
language(php).

runs_on_client(js).
runs_on_client(html5).
runs_on_client(css3).

ui_framework(angular, js).
ui_framework(vue, js).
ui_framework(react, js).
ui_framework(bootstrap, css3).

runs_on_server(python).
runs_on_server(js).
runs_on_server(java).
runs_on_server(php).

web_server_framework(flask, python).
web_server_framework(django, python).
web_server_framework(cake, php).
web_server_framework(laravel, php).
web_server_framework(yii, php).
web_server_framework(spark, java).
web_server_framework(spring, java).
web_server_framework(grails, java).
web_server_framework(express, js).
web_server_framework(loopback, js).

optimized_runtime_environment(nodejs, js).
optimized_runtime_environment(jvm, java).

% mobile app facts
mobile_app_os(android).
mobile_app_os(ios).

tool_for_mobile_os('Android Studio IDE', android).
tool_for_mobile_os(java, android).
tool_for_mobile_os(kotlin, android).

tool_for_mobile_os('Visual Studio IDE', ios).
tool_for_mobile_os(swift, ios).

mobile_app_framework(xamarin, 'C#').
mobile_app_framework(flutter, dart).

mobile_app_ide(xamarin_studio, xamarin).
mobile_app_ide(android_studio_ide, flutter).


% desktop app facts
desktop_app_language(java).
desktop_app_language('C#').
desktop_app_language('C++').
desktop_app_language(python).
desktop_app_ide(java, netbeans).
desktop_app_ide(java, eclipse).
desktop_app_ide('C#', 'Visual Studio').
desktop_app_ide('C++', 'Visual Studio').
desktop_app_ide(python, 'PyCharm').

% database facts
database(mysql).
database(postgresql).
database(sqlite).
lightweight_db(sqlite).

% ORM details
orm(java, hibernate).
orm(python, sqlalchemy).
orm(js, sequelize).
orm(php, eloquent).
orm('C++', odb).
orm('C#', entity).

% rules
mobile_app_db(X) :- database(X), lightweight_db(X).

fast_programming_language(X, Y):- language(X), optimized_runtime_environment(Y, X).
fast_programming_language_nd(X, Y):- 
	setof(X-Y, fast_programming_language(X, Y), Languages), member(X-Y, Languages).

client_side_language(X) :- language(X), runs_on_client(X).
client_side_language_nd(X) :- setof(X, client_side_language(X), Languages),
									member(X, Languages).

server_side_language(X) :- language(X), runs_on_server(X).
server_side_language_nd(X) :- setof(X, server_side_language(X), Languages),
									member(X, Languages).

client_side_framework(X, Y) :- client_side_language_nd(Y), ui_framework(X, Y).
client_side_framework_nd(X, Y) :- setof(X-Y, client_side_framework(X, Y), Frameworks),
									member(X-Y, Frameworks).

server_side_framework(X, Y) :- server_side_language_nd(Y), web_server_framework(X, Y).
server_side_framework_nd(X, Y) :- setof(X-Y, server_side_framework(X, Y), Frameworks),
									member(X-Y, Frameworks).

mobile_app_language(X, Y):- language(X), mobile_app_os(Y), tool_for_mobile_os(X, Y).

mobile_app_tool(X, Y) :- tool_for_mobile_os(X, Y), mobile_app_os(Y), !.

%UI

% Determine kind of application
find_out_software :-
	write('Welcome to software development. Software programs are written programs or procedures or rules and associated documentation pertaining to the operation of a computer system.'), nl, nl, 
	write('>>> A Web application is an application program that is stored on a remote server and delivered over the Internet through a browser interface.'), nl,
	write('>>> A Mobile application is a type of application software designed to run on a mobile device'), nl,
	write('>>> A Desktop application is any software that can be installed on a single computer and used to perform specific tasks.'), nl, nl, 
	write('Check tools to use for different software programs.'), nl,
	
	write("Do you want to build a Web application? (y/n)"), nl,
	read(X), nl,
	X=y, building_web_app;

	write("Do you want to build a Mobile application? (y/n)"), nl,
	read(X), nl,
	X=y, building_mobile_app;

	write("Do you want to build a Desktop application? (y/n)"), nl,
	read(X), nl,
	X=y, building_desktop_app;

	write(">>> Sorry, cannot determine which classification your application falls under.").


building_web_app :-
	write('>>> A Web application has two main structural components; a client and a server.'),nl,
	write('	~> A client is a user-friendly representation of a web app’s functionality that a user interacts with.'), nl,
	write('	~> A server is provides a service required by the user, usually contains the business logic.'), nl,nl,
	write("Which side are you building?"), nl,
	write("1. Client-side(default)"), nl,
	write("2. Server-side"), nl,
	write("3. Full-stack(Both the client-side and server-side)"), nl,

	read(C), web_app_side_choice(C).

	web_app_side_choice(C) :-
		C=:=3, write(">>> For full-stack use these languages:"), nl,
		list_client_side_languages,
		list_server_side_languages;

		C=:=2, list_server_side_languages;

		list_client_side_languages.


list_server_side_languages:-
	write(">>> For server-side use these languages:"), nl,
	forall(server_side_language_nd(L), format("* ~t~s,~n", L)),
	write(">>> It is worth noting that these languges run faster"), nl,
	forall(fast_programming_language_nd(X, _Y), format("* ~t~s,~n", X)),
	write("Which language would you prefer to use?"), nl,
	read(X), server_side_language_choice(X).
	server_side_language_choice(X):-
		write('Use either of the listed frameworks.(Frameworks makes software building easy).'),nl,
		forall(server_side_framework(F, X), format("* ~s framework ~n", F)), nl,
		write(">>> If you will need to use a database, use these Object Relational Mappers:"),
		forall(orm(X, Y), format("* ~s ORM ", Y)).


list_client_side_languages:-
	write(">>> For client-side use these languages:"), nl,
	forall(client_side_language_nd(L), format("* ~t~s,~n", L)),
	write(">>> Also use these client side frameworks(Frameworks makes software building easy)."), nl,
	forall(client_side_framework(F, L), format("* For ~s language use ~s framework~n", [L, F])).


building_mobile_app :-
	nl,
	write("Should it use a database? (y/n)"), nl,
	read(X), db_choice(X).
	db_choice(X) :- X=y, mobile_app_with_db.
	db_choice(_X) :- mobile_app_os.


building_desktop_app :-
	nl,
	write("Desktop apps can be built using:"), nl,
	forall(desktop_app_language(Z), format("* ~s\n", Z)),
	write("Which langauge would you want to use?"), nl,
	read(C), desktop_language_choice(C).
	
	desktop_language_choice(C) :-
		desktop_app_ide(C, IDE),
		format(">>> For ~s use ~s IDE", [C, IDE]).
	desktop_language_choice(_C) :- write("Could not determine which IDE to use for that language"), nl.


mobile_app_with_db :-
	write(">>> You should use ["),
	forall(mobile_app_db(Z), write(Z)),
	write("] as possible databases."), nl,
	write(">>> This is because mobile phones have smaller memory hence using a light-weight database is preferrable"), nl,
	mobile_app_os.


mobile_app_os :-
	nl,
	write("Which Mobile OS are you building an app for?"), nl,
	write("1. Android (default)"), nl,
	write("2. iOS"), nl,
	write("3. Both"), nl,
	read(C), os_choice(C).
	os_choice(C) :- C=:=3, write(">>> For both iOS and Android use "), nl,
					forall(mobile_app_framework(X, Y), format("* Use ~s framework with ~s language or~n", [X, Y])),
					write(">>> Furthermore:"), nl,
					forall(mobile_app_ide(X, Y), format("* Use ~s IDE for ~s framework or~n", [X, Y])).
	os_choice(C) :- C=:=2, write(">>> For iOS use:"), nl,
					forall(mobile_app_language(Z, ios), format("* ~s programming language~n", Z)), nl,
					forall(mobile_app_tool(X, ios), format('Also use ~s', X)).
	os_choice(_C) :- write(">>> For Android use "), nl,
					forall(mobile_app_language(Z, android), format("* ~s programming language~n", Z)), nl,
					forall(mobile_app_tool(X, android), format('Also use ~s', X)).