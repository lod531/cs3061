%logical consequence. Checks if atom X is a logical consequence of the knowledge base KB
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


%lcRule uses lc, where lc stands for "logical consequence". lcRule checks if the rule, in the form of
%[Rule, RequiredAtom0, RequiredAtom1...] is a logical consequence in the context of the knowledge base 
%This is done by simply appending the atoms RequiredAtom0, RequiredAtom1... onto the knowledge base
%and checking if Rule falls out as a logical consequence.

lcRule([TargetAtom|AssumedAtoms], KnowledgeBase) :- 	itemize(AssumedAtoms, ItemizedAssumedAtoms), 
							append(ItemizedAssumedAtoms, KnowledgeBase, AugmentedKnowledgeBase),
							lc(TargetAtom, AugmentedKnowledgeBase).

%itemize wraps each element of the list in a list wrapper, essentially adding a level of nesting.
itemize([], []).
itemize([H|T], [[H]|T0]) :- itemize(T, T0).



%As for part two, the minimal conflict set is [ [d], [e, g], [e, h] ]. The reasoning is as follows
%So there are two false atoms, namely [false, a] and [false, b, c]. So, for a conflict for [false, a], 
%[a, d] must hold, and so [d] forms a conflict. That exhausts possibilities for [false, a]. Now, for
%[false, b, c] to be a conflict, [b] and [c] must be true. Thus [e] must be true, as [b, e]. Further,
%[[d], [f]] must be true as [c, d, f], as well as [c, g] and [c, h]. This gives a set of conflicts
%[ [d], [e, g], [e, d, f], [e, g] and [e, h]. But [d] is shared by [d] and [e, d, f], so [e, d, f] is
%reduced to [e, f], which is not a conflict. Thus, the minimal conflict set is:

%[d, [e, g], [e. h]]
