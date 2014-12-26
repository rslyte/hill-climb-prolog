%Ryan Slyter
%CS355
%Assignment 4: Prolog

%PROBLEM 1
%X is var, Y is statelist, Z is output
%you keep taking head off of Y, comparing it to X, and set Z to broken down tail
%if they match.
eval-var(X,[],[]).
eval-var(X,[A|B],Z) :- X=A, B=[C|D], Z=C.
eval-var(X,Y,Z) :- Y=[A|B], B=[C|D], eval-var(X,A,Z).
eval-var(X,Y,Z) :- Y=[A|B], B=[C|D], \+eval-var(X,A,Z), eval-var(X,B,Z).
eval-var(X,Y,Z) :- Y=[A|B], B=[], eval-var(X,A,Z).

%PROBLEM 2
%X is statelist, [A|B] is the clause, Z is output (C,D,E,F are temps)
%keep calling eval-var on A and if it ever come up true,
%return true. If it's ever empty return false.
eval-clause(X,[],false).
eval-clause(X,[A|B],Z) :- not(A=[C|D]),eval-var(A,X,Z),Z=true. 
eval-clause(X,[A|B],Z) :- not(A=[C|D]), eval-var(A,X,false),eval-clause(X,B,Z).
eval-clause(X,[A|B],Z) :- A=[C|D], C=not, D=[E|F], eval-var(E,X,false), Z=true.
eval-clause(X,[A|B],Z) :- A=[C|D], C=not, D=[E|F], eval-var(E,X,true), eval-clause(X,B,Z).

%PROBLEM 3
%Just call flatten and subtract(not) on a list and you have all the vars.
get-vars([],Z).
get-vars(X,Z) :- flatten(X,R), subtract(R,[not],Z), get-vars([],Z).

%PROBLEM 4
%Just call sort() on get-vars (because getvars works on a list of clauses)
%and it will take result of get-vars and remove dupicates
get-all-vars([],[]).
get-all-vars(X,Z) :- get-vars(X,R), sort(R,Z).

%PROBLEM 5
%Like Scheme assignment, I wrote a base case method to see if
%there are satisified clauses in X, and if there aren't, I return
%True, which unsat-clauses returns that list. In unsat-clauses, X is the clause list, Y is the statelist, Z is
%output. I keep calling eval-clause and appending the head to the clause list
%and call nosat or I just work with the tail if it came out true. If the clause
%list breaks down to [] I just return [].
nosat([],Y,true).
nosat(X,Y,Z) :- X=[A|B], \+eval-clause(Y,A,Z), nosat(B,Y,Z).
unsat-clauses([],Y,[]).
unsat-clauses(X,Y,X) :- nosat(X,Y,true).
unsat-clauses([A|B],Y,Z) :- eval-clause(Y,A,true), unsat-clauses(B,Y,Z).
unsat-clauses([A|B],Y,Z) :- \+eval-clause(Y,A,Z), append(B,A,S), unsat-clauses(S,Y,Z).

%PROBLEM 6
%X is var, [A|B]/R is statelist, Z if output
%keep appending head to end of list if X != A
%if they are equal make a new state with the opposite
%bool, append, and return the list.
flip-var([],R,Z) :- Z=R,!.
flip-var(X,[A|B],Z) :- A=[C|D], not(X=C), append(B,A,R), flip-var(X,R,Z).
flip-var(X,[A|B],Z) :- A=[C|D], X=C, D=[E|F], E=true, append([X],[false],R), append([R],B,S), flip-var([],S,Z).
flip-var(X,[A|B],Z) :- A=[C|D], X=C, D=[E|F], E=false, append([X],[true],R), append([R],B,S), flip-var([],S,Z).
