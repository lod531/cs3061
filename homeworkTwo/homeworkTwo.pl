lc(X,KB) :- cn(C,KB), member(X,C).

cn(C,KB) :- cn([],C,KB).
cn(TempC,C,KB) :- 	member([H|B],KB),
			all(B,TempC),
			nonmember(H,TempC),
			cn([H|TempC],C,KB).
cn(C,C,_).

all([],_).
all([H|T],L) :- member(H,L), all(T,L).

nonmember(_,[]).
nonmember(X,[H|T]) :- X\=H, nonmember(X,T).


lcRule([TargetAtom|AssumedAtoms], KnowledgeBase) :- 	itemize(AssumedAtoms, ItemizedAssumedAtoms), 
							append(ItemizedAssumedAtoms, KnowledgeBase, AugmentedKnowledgeBase),
							lc(TargetAtom, AugmentedKnowledgeBase).

itemize([], []).
itemize([H|T], [[H]|T0]) :- itemize(T, T0).

