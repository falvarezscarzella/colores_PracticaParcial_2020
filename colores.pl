% BASE DE CONOCIMIENTO

% precio(tipo de prenda, tela de la prenda, precio de venta)
% los tipos de tela son: estampado(patron, lista de colores que tiene) o 
% liso(color)
precio(remera, estampado(floreado, [rojo, verde, blanco]), 500).
precio(remera, estampado(rayado, [verde, negro, rojo]), 600).
precio(buzo, liso(azul), 1200).
precio(vestido, liso(negro), 3000).
precio(saquito, liso(blanco), 1500).

prenda(vestido, estampado(rayado, [negro,blanco])).
prenda(saquito, liso(gris)).
prenda(prenda(Prenda,Tela)):- precio(Prenda,Tela,_).

paleta(sobria, negro).	
paleta(sobria, azul).  	
paleta(sobria, blanco).        
paleta(sobria, gris).
paleta(alegre, verde).	
paleta(alegre, blanco).  
paleta(alegre, amarillo).
paleta(furiosa, rojo).  
paleta(furiosa, violeta).  
paleta(furiosa, fucsia).

color(Color):- paleta(_,Color).

% PUNTO 1
/*coloresCombinables/2 relaciona dos colores distintos 
si se encuentran en una misma paleta o si uno de ellos 
es el negro, que puede combinarse con cualquier otro.*/

estanEnLaMismaPaleta(Color1,Color2):-
    paleta(Paleta,Color1),
    paleta(Paleta,Color2),
    Color1 \= Color2.

algunoEsNegro(negro,_).
algunoEsNegro(_,negro).

coloresCombinables(Color1,Color2):-
    estanEnLaMismaPaleta(Color1,Color2).
coloresCombinables(Color1,Color2):-
    color(Color1),
    color(Color2),
    not(estanEnLaMismaPaleta(Color1,Color2)),
    algunoEsNegro(Color1,Color2).
    

% PUNTO 2
/*colorinche/1 se cumple para un functor prenda/2
 si la tela de la misma es estampada y no tiene dos 
 colores que pertenezcan a una misma paleta.*/

estampadoConColoresEnDistintaPaleta(estampado(_,Colores)):-
    member(Color1,Colores),
    member(Color2,Colores),
    not(estanEnLaMismaPaleta(Color1,Color2)).

colorinche(prenda(Prenda,Tela)):- 
    prenda(prenda(Prenda, Tela)), 
    estampadoConColoresEnDistintaPaleta(Tela).

% PUNTO 3
/*colorDeModa/1 se cumple para un color si todas
 las prendas estampadas a la venta tienen ese color.*/   

colorDeModa(Color):-
    color(Color),
    forall(precio(_,estampado(_,Colores),_),member(Color,Colores)).

% PUNTO 4
/*combinan/2 relaciona dos prendas si sus telas quedan bien
 juntas, lo cual se cumple si las dos son lisas y los colores
  son combinables, o si una es estampada y la otra lisa y alguno 
  de los colores de la estampa es combinable con el color de la 
  tela lisa. No quedan bien dos telas estampadas juntas.*/
    
telasQuedanBien(liso(Color1),liso(Color2)):-
    coloresCombinables(Color1,Color2).
telasQuedanBien(liso(ColorLiso),estampado(_,Colores)):-
    member(ColorEstampado,Colores),
    coloresCombinables(ColorLiso,ColorEstampado).
telasQuedanBien(estampado(_,Colores),liso(ColorLiso)):-
    member(ColorEstampado,Colores),
    coloresCombinables(ColorLiso,ColorEstampado).    
    
combinan(prenda(Prenda,Tela1),prenda(OtraPrenda,Tela2)):-
    prenda(prenda(Prenda,Tela1)),
    prenda(prenda(OtraPrenda,Tela2)),
    Prenda \= OtraPrenda,
    telasQuedanBien(Tela1,Tela2).

% PUNTO 5
/*precioMaximo/2 relaciona un tipo de prenda con su precio
 máximo de todas las prendas a la venta de ese mismo tipo.*/

precioMaximo(Prenda,PrecioMaximo):-
    precio(Prenda,_,PrecioMaximo),
    not((precio(Prenda,_,Precio),Precio > PrecioMaximo)).

precioMaximo2(Prenda,PrecioMaximo):-
    precio(Prenda,_,PrecioMaximo),
    forall(precio(Prenda,_,Precio),Precio =< PrecioMaximo).

% PUNTO 6
/*conjuntoValido/1 dada una lista de prendas, se considera
 un conjunto válido si todas las que la componen combinan con 
 todas las otras y tiene al menos dos elementos. 
 No se requiere que sea inversible.*/

conjuntoValido(Prendas):-
    length(Prendas,Cantidad),
    Cantidad >= 2,
    forall((member(Prenda,Prendas),member(OtraPrenda,Prendas),Prenda \= OtraPrenda), combinan(Prenda,OtraPrenda)).
    