% dropAny(?Elem,?List,?OutList)
dropAny(X,[],[]).
dropAny(X,[X|T],T).
dropAny(X,[H|Xs],[H|L]):-dropAny(X,Xs,L).

% EX 1.1

% dropFirst(?Elem,?List,?OutList)
dropFirst(X,Y,Z):-dropAny(X,Y,Z),!.

% dropLast(?Elem,?List,?OutList)
dropLast(X,[H|Xs],[H|L]):-dropLast(X,Xs,L),!.
dropLast(X,[X|T],T).

% dropAll(?Elem,?List,?OutList)
dropAll(X,[],[]).
dropAll(X,[X|Xs],R):-dropAll(X,Xs,R),!.
dropAll(X,[H|Xs],[H|L]):-dropAll(X,Xs,L).

% EX 2.1
% fromList(+List,-Graph)
fromList([_],[]).
fromList([H1,H2|T],[e(H1,H2)|L]):- fromList([H2|T],L).

% EX 2.2
% fromCircList(+List,-Graph)
fromCircList([H1,H2|T],[e(H1,H2)|L]):- fromCircList([H2|T],L,H1,H2).
fromCircList([_],[e(U,F)],F,U).
fromCircList([H1,H2|T],[e(H1,H2)|L],F,_):- fromCircList([H2|T],L,F,H2).

% EX 2.3
% dropNode(+Graph, +Node, -OutGraph)
% drop all edges starting and leaving from a Node
% use dropAll defined in 1.1
dropNode(G,N,O):- dropAll(G,e(N,_),G2), dropAll(G2,e(_,N),O).

% EX 2.4
% reaching(+Graph, +Node, -List)
% all the nodes that can be reached in 1 step from Node
% possibly use findall, looking for e(Node,_) combined
% with member(?Elem,?List)
reaching(G,O,Res):- findall(E,member(e(O,E),G),Res).

% EX 2.5
% anypath(+Graph, +Node1, +Node2, -ListPath)
% a path from Node1 to Node2
% if there are many path, they are showed 1-by-1
anypath([e(O,E)|T],O,E,[e(O,E)]).
anypath([e(O,X)|T],O,E,[e(O,X)|R]):- anypath(T,X,E,R).
anypath([e(X,Y)|T],O,E,R):- anypath(T,O,E,R).

% EX 2.6
% allreaching(+Graph, +Node, -List)
% all the nodes that can be reached from Node
% Suppose the graph is NOT circular!
% Use findall and anyPath!
allreaching(G,O,R):- findall(E,anypath(G,O,E,_),R).

% EX 3

%get_at_index(+List,@Index,-Element)
get_at_index(L,I,E):- get_at_index(L,0,I,E).
get_at_index([H|_],Ci,I,H):- Ci == I.
get_at_index([_|T],Ci,I,E):- Ci < I, Ci2 is Ci + 1, get_at_index(T,Ci2,I,E).

% place_in_row(+Row, +Player, -UpdatedRow)
place_in_row(R,P,X):- place_in_row(R,0,P,X).
place_in_row([H|T],I,P,[P|T]):- I<3, H \= x, H \= o.
place_in_row([H|T],I,P,[H|X]):- I<3, I2 is I + 1, place_in_row(T,I2,P,X).

% place_in_table(@Table, @Player, -NewTable)
place_in_table(T,P,X):- place_in_table(T,0,P,X).
place_in_table([H|T],I,P,[X|T]):- I<3, place_in_row(H,P,X).
place_in_table([H|T],I,P,[H|X]):- I<3, I2 is I + 1, place_in_table(T,I2,P,X).

% all_same_in_list(+List,+Element)
all_same_in_list([],_).
all_same_in_list([H|T],E):- H == E, all_same_in_list(T,E).

% check_rows_win(+Table, @Player)
check_rows_win([H|_],P):- all_same_in_list(H,P),!.
check_rows_win([_|T],P):- check_rows_win(T,P).

% check_col(+Table, @Player, @Column)
check_col([H|T],P,C):- get_at_index(H,C,P), check_col(T,P,C).
check_col([],_,_).

% check_cols_win(@Table, @Player)
check_cols_win(T,P):- check_cols_win(T,P,0).
check_cols_win(T,P,I):- I<3, check_col(T,P,I), !.
check_cols_win(T,P,I):- I<3, I2 is I + 1, check_cols_win(T,P,I2).

% check_diagonal_win(+Table, +Index, @Step, @Player)
check_diagonal_win([],_,_,_).
check_diagonal_win([H|T],I,S,P):- get_at_index(H,I,E), E == P, I2 is I + S, check_diagonal_win(T,I2,S,P).

% is_row_full(+Row)
is_row_full([]).
is_row_full([H|T]):- H == x, is_row_full(T),!.
is_row_full([H|T]):- H == o, is_row_full(T).

% check_even(+Table)
check_even([]).
check_even([H|T]):- is_row_full(H), check_even(T).

%get_result(@Table, @Player, -Result)
get_result(T,P,win_row(P)):- check_rows_win(T,P),!.
get_result(T,P,win_col(P)):- check_cols_win(T,P),!.
get_result(T,P,win_back_diagonal(P)):- check_diagonal_win(T,0,1,P),!.
get_result(T,P,win_front_diagonal(P)):- check_diagonal_win(T,2,-1,P),!.
get_result(T,P,even):- check_even(T),!.
get_result(_,_,nothing).

% next(@Table, @Player, -Result, -NewTable)
next(T,P,R,X):- place_in_table(T,P,X), get_result(X,P,R).

% game(@Table,@Player,-Result,-TableList)
game(Table,Player,Result,TableList):- game(Table,Player,Result,TableList,nothing).
game(Table,Player,Result,[NewTable|TableList],nothing):- Player == x, next(Table,Player,NextResult,NewTable), game(NewTable,o,Result,TableList,NextResult).
game(Table,Player,Result,[NewTable|TableList],nothing):- Player == o, next(Table,Player,NextResult,NewTable), game(NewTable,x,Result,TableList,NextResult).
game(T,P,Lr,[],Lr):- Lr \= nothing.
