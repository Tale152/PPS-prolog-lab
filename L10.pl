% EX 1.1
% search(Elem, List)
search(X, [X|_]).
search(X, [_|Xs]) :- search(X, Xs).

% EX 1.2
% search2(Elem, List)
% looks for two consecutive occurrences of Elem
search2(X, [X,X|_]).
search2(X, [_|Xs]):- search2(X,Xs).

% EX 1.3
% search_two(Elem,List)
% looks for two occurrences of Elem with any element in between!
search_two(X, [X,_,X|_]).
search_two(X, [_|Xs]):- search_two(X,Xs).

% EX 1.4
% search_anytwo(Elem,List)
% looks for any Elem that occurs two times, anywhere
search_anytwo(X, [X|T]):- search_anytwo_second(X,T).
search_anytwo(X, [_|T]):- search_anytwo(X,T).
search_anytwo_second(X, [X|T]).
search_anytwo_second(X, [_|T]):- search_anytwo_second(X,T).

% EX 2.1
% size(List, Size)
% Size will contain the number of elements in List
size([],0).
size([_|T],M):- size(T,N), M is N+1.

% EX 2.2
% size(List,Size)
% Size will contain the number of elements in List, written using notation zero, s(zero), s(s(zero))..
size_s([],zero).
size_s([_|T],s(X)):- size_s(T,X).

% EX 2.3
% sum(List,Sum)
sum([],0).
sum([H|T],R):- sum(T,X), R is H+X.

% EX 2.4
% average(List,Average)
% it uses average(List,Count,Sum,Average)
average(List,A) :- average(List,0,0,A).
average([],C,S,A) :- A is S/C.
average([X|Xs],C,S,A) :-
	C2 is C+1,
	S2 is S+X,
	average(Xs,C2,S2,A).

% EX 2.5
% max(List,Max)
% Max is the biggest element in List
% Suppose the list has at least one element
max([H|T],M):- max(T,M,H).
max([],Cm,Cm).
max([H|T],M,Cm):- H>Cm, max(T,M,H).
max([H|T],M,Cm):- H=<Cm, max(T,M,Cm).

% EX 2.6
% max(List,Max,Min)
% Max is the biggest element in List
% Min is the smallest element in List
% Suppose the list has at least one element
minmax([H|T],Min,Max):- minmax(T,Min,Max,H,H).
minmax([],Cmin,Cmax,Cmin,Cmax).
minmax([H|T],Min,Max,Cmin,Cmax):- H<Cmin, minmax(T,Min,Max,H,Cmax).
minmax([H|T],Min,Max,Cmin,Cmax):- H>Cmax, minmax(T,Min,Max,Cmin,H).
minmax([H|T],Min,Max,Cmin,Cmax):- H>=Cmin, H=<Cmax, minmax(T,Min,Max,Cmin,Cmax).

% EX 3.1
% same(List1,List2)
% are the two lists exactly the same?
same([],[]).
same([X|Xs],[X|Ys]):- same(Xs,Ys).

% EX 3.2
% all_bigger(List1,List2)
% all elements in List1 are bigger than those in List2, 1 by 1
all_bigger([],[]).
all_bigger([X|Xs],[Y|Ys]):- X>Y, all_bigger(Xs,Ys).

% EX 3.3
% sublist(List1,List2)
% List1 should contain elements all also in List2
sublist([],[_|_]).
sublist([H|T], L):- search(H,L), sublist(T,L).

% EX 4.1
% seq(N,List)
seq(0,[]).
seq(N,[0|T]):- N > 0, N2 is N-1, seq(N2,T).

% EX 4.2
% seqR(N,List)
seqR(0,[0]).
seqR(N,[N|T]):- N > 0, N2 is N-1, seqR(N2,T).

% EX 4.3
% seqR2(N,List)
% example: seqR2(4,[0,1,2,3,4]).
seqR2(N,L):- N>=0, seqR2(N,0,L).
seqR2(N,N,[N]).
seqR2(N,C,[C|T]):- C<N, C2 is C+1, seqR2(N,C2,T).

% EX 4.4
% inv(List,List)
% example: inv([1,2,3],[3,2,1]).
inv([], L, L).
inv(L, LG) :- inv(L, LG, []).
inv([H|T], LG, V) :- inv(T, LG, [H|V]).

% EX 4.6
% times(List,N,List)
% example: times([1,2,3],3,[1,2,3,1,2,3,1,2,3]).
times(L,0,[]).
times(L,N,R):- N>0, append(L,[],P), N2 is N-1, times(L,N2,P,R).
times(L,0,P,P).
times(L,N,P,R):- N>0, append(L,P,P2), N2 is N-1, times(L,N2,P2,R).

% EX 4.5
% double(List,List)
% example: double([1,2,3],[1,2,3,1,2,3]).
double(L,R):- times(L,2,R).

% EX 4.7
% proj(List,List)
% example: proj([[1,2],[3,4],[5,6]],[1,3,5]).
proj([],[]).
proj([[H1|_]|T0],[H1|R]):- proj(T0,R).
