

/* DATABASE

    movie(M, Y) <- movie M came out in year Y
    director(M, D) <- movie M was directed by director D
    actor(M, A, R) <- actor A played role R in movie M
    actress(M, A, R) <- actress A played role R in movie M
    %( condition -> then_clause ; else_clause )
    
*/

escribir:-
	telling(OldStream),
	tell('dataBase.pl'),
	%write(':-dynamic (actor/3),(movie/2),(actress/3),(director/2).'),nl,
	listing(escribir),
	listing(masDeUno),
	listing(menu),
	listing(hazOpcion),
	listing(switch),
	listing(movie/2),
	listing(director/2),
	listing(actor/3),
	listing(actress/3),
	told,
	tell(OldStream).
	
masDeUno(Pelicula):- findall(D, director(Pelicula,D),B),length(B,Num), Num > 1. 

menu:-
	writeln('Dame una opcion:'),
	writeln('1. Encontrar informacion de pelicula' ),
	writeln('2. Agregar informacion de una pelicula'),
	writeln('3. Agregar una nueva pelicula'),
	writeln('4. Modificar informacion de una pelicula'),
	writeln('5. Borrar informacion de una pelicula'),
	writeln('6. Salir'),
	read(Opcion),
	hazOpcion(Opcion).

hazOpcion(1):-
	writeln('Encontrar informacion de pelicula'),
	writeln('De que pelicula quieres saber'),
	read(Pelicula),
	(movie(Pelicula,_) -> writeln('La pelicula esta en la base de datos') ; writeln('No se encuentra en la base de datos'),menu),
	write('Año: '),movie(Pelicula,Y),writeln(Y),
	write('Director(es):'),findall(D,(movie(Pelicula,Y),director(Pelicula,D)),B),writeln(B),
	write('actores: '),findall(A,actor(Pelicula,A,_),L2),write(L2),nl,
    write('actrices: '),findall(A,actress(Pelicula,A,_),L3),write(L3),nl,nl,
	menu.
	
hazOpcion(2):-
	writeln('Agregar informacion de una pelicula'),
	writeln('A que pelicula le quieres agregar informacion'),
	read(Pelicula),
	(movie(Pelicula,_) -> writeln('La pelicula esta en la base de datos') ; writeln('No se encuentra en la base de datos'),menu),
	writeln('Que tipo de informacion quiere agregar'),
	%No esta contiene año porque el año se agrega cuando se crea la pelicula.
	writeln('1. Actor'),
	writeln('2. Actris'),
	writeln('3. Director'),
	read(Info),
	switch(Info,[
		1 : (writeln('Dame el nombre en minusculas'),read(Actor),writeln('Dame el rol en minusculas'),read(Rol),
			  assert(actor(Pelicula,Actor,Rol))),  																		%open('movies.pl',append, S),write(S,actor(Pelicula,Actor,Rol)),put_char(S,.),nl(S),close(S)  ),
		2 : (writeln('Dame el nombre en minusculas'),read(Actor),writeln('Dame el rol en minusculas'),read(Rol),
			  assert(actress(Pelicula,Actor,Rol))),   																	%open('movies.pl',append, S),write(S,actress(Pelicula,Actor,Rol)),put_char(S,.),nl(S),close(S) ),
		3 : (writeln('Dame el nombre del director en minusculas'),read(Director),assert(director(Pelicula,Director)))	%open('movies.pl',append, S),write(S,director(Pelicula,Director)),put_char(S,.),nl(S),close(S) ),
		]),
	escribir,
	menu.
	
hazOpcion(3):-
	writeln('Dame el titulo de la nueva pelicula'),
	read(Pelicula),
	writeln('Dame el año de la pelicula'),
	read(Year),
	assert(movie(Pelicula,Year)).

hazOpcion(4):-
	writeln('Modificar informacion de una pelicula'),
	writeln('A que pelicula le quieres agregar informacion'),
	read(Pelicula),
	(movie(Pelicula,_) -> writeln('La pelicula esta en la base de datos') ; writeln('No se encuentra en la base de datos'),menu),
	writeln('Que informacion quieres modificar'),
	writeln('1. Titulo de pelicula'),
	writeln('2. Año de estreno de pelicula'),
	writeln('3. Director de una pelicula'),
	writeln('4. Rol de actor'),
	writeln('5. Rol de actris'),
	read(Info),	
	switch(Info,[
		1: (writeln('Dame el nuevo titulo de la pelicula con _ en vez de espacios y minusculas'),
			read(Nuevo)  ),
		2: (writeln('Dame el año de estreno'),read(Year),retract(movie(Pelicula,_)),assert(movie(Pelicula,Year)) ),
		3: (    (masDeUno(Pelicula) ->  
				(writeln('La pelicula tiene mas de un director'),writeln('Dame el nombre del viejo director'),
				read(Viejo),writeln('Ahora dame el nombre del nuevo director'),read(Director),
				retract(director(Pelicula,Viejo)), assert(director(Pelicula,Director))) 
				; 
				(writeln('Dame el nuevo director'),read(Director), 
				retract(director(Pelicula,_)), assert(director(Pelicula,Director)))       
			)),
		4: (writeln('Dime a que actor le quieres cambiar el Rol'),read(Actor),writeln('Dame su nuevo rol'),read(Rol),
			retract(actor(Pelicula,Actor,_)),assert(actor(Pelicula,Actor,Rol))), 	
		5: (writeln('Dime a que actris le quieres cambiar el Rol'),read(Actor),writeln('Dame su nuevo rol'),read(Rol),
			retract(actress(Pelicula,Actor,_)),assert(actress(Pelicula,Actor,Rol))) 	
	]),
	menu.

hazOpcion(5):-
	writeln('Borrar informacion de una pelicula'),
	writeln('A que pelicula le quieres borar informacion'),
	read(Pelicula),
	writeln('Que tipo de informacion quiere borrar'),
	writeln('1. Actor'),
	writeln('2. Actris'),
	writeln('3. Director'),
	writeln('4. Año'),
	writeln('5. Borrar toda la informacion de una pelicula'),
	read(Info),
	switch(Info,[
		1 : (writeln('Dame el nombre del actor, en minusculas'),read(Actor),retract(actor(Pelicula,Actor,_))),	%open('movies.pl',erase, S),erase(actor(Pelicula,Actor,_)),nl(S),close(S) ),
		2 : (writeln('Dame el nombre de la actris en minusculas'),read(Actor),retract(actress(Pelicula,Actor,_))),
		3 : (writeln('Dame el nombre del director en minusculas'),read(Director),retract(director(Pelicula,Director))),
		4 :	(writeln('Borrando el año'),retract(movie(Pelicula,_)),assert(movie(Pelicula,_))),
		5 : (writeln('Borrando todo...'),retract(movie(Pelicula,_)),retractall(director(Pelicula,_)),
			 retractall(actor(Pelicula,_,_)),retractall(actress(Pelicula,_,_)))  
		]),
	escribir,
	menu.

	
hazOpcion(6):-
	%writeln('Realizando todos los cambios en la base de datos')
	writeln('Hasta pronto camarada').


switch(X, [Val:Goal|Cases]) :-
    ( X=Val ->
        call(Goal)
    ;
        switch(X, Cases)
    ).
	
	
							

%hazDatos:- open('dataBase.pl',append,S),set_output(S),listing(movie/2),listing(director/2),listing(actor/3),listing(actress/3),nl(S),close(S).

%elimina:- retract(actor(charly,charly,elvato)).


%borra:-
%	open('dataBase.pl',write,S),
%	retract(movie(prueba,1995)),
%	set_output(S),
%	listing(movie/2),
%	listing(director/2),
%	listing(actor/3),
%	listing(actress/3),
%	close(S).
	
%cambia(M,N):-
%	movie(M,An), %Encuentra info
%	findall(D,director(M,D),Ld),
%	findall((A1,P1),actor(M,A1,P1),La1),
%	findall((A2,P2),actress(M,A2,P2),La2),
%	retract(movie(M,An)), 	%	Borra
%	retractall(director(M,_)),
%	retractall(actor(M,_,_)),
%	retractall(actress(M,_,_)),
%	assert(movie(N,An)), % Actualiza
%	(member(X,Ld),assert(director(N,X)),fail;true),
%	(member((X,Y),La1),assert(actor(N,X,Y)),fail;true),
%	(member((X,Y),La2),assert(actress(N,X,Y)),fail;true).
%	
	


%	switch(Info,[
%		1: (writeln('Dame el nombre del actor que quieres borrar, en minusculas'), read(Actor),
%			 open('movies.pl',S),retract(actor(Infor,Actor,_)),close(S)    )
%		%2:
%		%3:
%		%4:
%		%5:
%	]),


%open('nombrearchivo.txt'),write(S),set_output(S),write('Esto se va al archivo'),nl,close(S).
%open('sal.txt,write S),write(S,'hola'),nl(S),close(S).
%listing(movie/2).
%open('nombrearchivo.txt',write,S),set_output(S),listing(actor/3),listin(movie/2),nl,close(S).
%open('sal.txt',write S),clause(movie(anna,A),_),write(S,movie(anna,A)),clause(actor(anna,N,P)_),nl,close(S).

%General
%open(Nombre, Tipo, Stream).
%tipo: write, append,read
%stream: close(Stream )
%set_output(Stream)
%write(Stream, 'cosa')
%listing(Nombre/aridad)
%nl(Stream)
% Leer un archivo: consult(Nombre archivo.txt).
%retractall(movie/2). ---> Borra todo

% Para el segundo ejercicio --->   read(A),A


 %Esto permite borrar de un archivo
:-dynamic 
		(actor/3),
		(movie/2),
		(actress/3),
		(director/2). 


:- discontiguous
        movie/2,
        director/2,
        actor/3,
        actress/3,
        hazOpcion/1.

movie(american_beauty, 1999).
director(american_beauty, sam_mendes).
actor(american_beauty, kevin_spacey, lester_burnham).
actress(american_beauty, annette_bening, carolyn_burnham).
actress(american_beauty, thora_birch, jane_burnham).
actor(american_beauty, wes_bentley, ricky_fitts).
actress(american_beauty, mena_suvari, angela_hayes).
actor(american_beauty, chris_cooper, col_frank_fitts_usmc).
actor(american_beauty, peter_gallagher, buddy_kane).
actress(american_beauty, allison_janney, barbara_fitts).
actor(american_beauty, scott_bakula, jim_olmeyer).
actor(american_beauty, sam_robards, jim_berkley).
actor(american_beauty, barry_del_sherman, brad_dupree).
actress(american_beauty, ara_celi, sale_house_woman_1).
actor(american_beauty, john_cho, sale_house_man_1).
actor(american_beauty, fort_atkinson, sale_house_man_2).
actress(american_beauty, sue_casey, sale_house_woman_2).
actor(american_beauty, kent_faulcon, sale_house_man_3).
actress(american_beauty, brenda_wehle, sale_house_woman_4).
actress(american_beauty, lisa_cloud, sale_house_woman_5).
actress(american_beauty, alison_faulk, spartanette_1).
actress(american_beauty, krista_goodsitt, spartanette_2).
actress(american_beauty, lily_houtkin, spartanette_3).
actress(american_beauty, carolina_lancaster, spartanette_4).
actress(american_beauty, romana_leah, spartanette_5).
actress(american_beauty, chekeshka_van_putten, spartanette_6).
actress(american_beauty, emily_zachary, spartanette_7).
actress(american_beauty, nancy_anderson, spartanette_8).
actress(american_beauty, reshma_gajjar, spartanette_9).
actress(american_beauty, stephanie_rizzo, spartanette_10).
actress(american_beauty, heather_joy_sher, playground_girl_1).
actress(american_beauty, chelsea_hertford, playground_girl_2).
actress(american_beauty, amber_smith, christy_kane).
actor(american_beauty, joel_mccrary, catering_boss).
actress(american_beauty, marissa_jaret_winokur, mr_smiley_s_counter_girl).
actor(american_beauty, dennis_anderson, mr_smiley_s_manager).
actor(american_beauty, matthew_kimbrough, firing_range_attendant).
actress(american_beauty, erin_cathryn_strubbe, young_jane_burnham).
actress(american_beauty, elaine_corral_kendall, newscaster).

movie(anna, 1987).
director(anna, yurek_bogayevicz).
actress(anna, sally_kirkland, anna).
actor(anna, robert_fields, daniel).
actress(anna, paulina_porizkova, krystyna).
actor(anna, gibby_brand, director_1).
actor(anna, john_robert_tillotson, director_2).
actress(anna, julianne_gilliam, woman_author).
actor(anna, joe_aufiery, stage_manager).
actor(anna, lance_davis, assistant_1).
actress(anna, deirdre_o_connell, assistant_2).
actress(anna, ruth_maleczech, woman_1_woman_named_gloria).
actress(anna, holly_villaire, woman_2_woman_with_bird).
actress(anna, shirl_bernheim, woman_3_woman_in_white_veil).
actress(anna, ren_e_coleman, woman_4_woman_in_bonnet).
actress(anna, gabriela_farrar, woman_5_woman_in_black).
actress(anna, jordana_levine, woman_6_woman_in_turban).
actress(anna, rosalie_traina, woman_7_woman_in_gold).
actress(anna, maggie_wagner, actress_d).
actor(anna, charles_randall, agent).
actress(anna, mimi_weddell, agent_s_secretary).
actor(anna, larry_pine, baskin).
actress(anna, lola_pashalinski, producer).
actor(anna, stefan_schnabel, professor).
actor(anna, steven_gilborn, tonda).
actor(anna, rand_stone, george).
actress(anna, geena_goodwin, daniel_s_mother).
actor(anna, david_r_ellis, daniel_s_father).
actor(anna, brian_kohn, jonathan).
actress(anna, caroline_aaron, interviewer).
actor(anna, vasek_simek, czech_demonstrator_1).
actor(anna, paul_leski, czech_demonstrator_2).
actor(anna, larry_attile, czech_demonstrator_3).
actress(anna, sofia_coppola, noodle).
actor(anna, theo_mayes, dancing_dishwasher).
actress(anna, nina_port, dancing_dishwasher).

movie(barton_fink, 1991).
director(barton_fink, ethan_coen).
director(barton_fink, joel_coen).
actor(barton_fink, john_turturro, barton_fink).
actor(barton_fink, john_goodman, charlie_meadows).
actress(barton_fink, judy_davis, audrey_taylor).
actor(barton_fink, michael_lerner, jack_lipnick).
actor(barton_fink, john_mahoney, w_p_mayhew).
actor(barton_fink, tony_shalhoub, ben_geisler).
actor(barton_fink, jon_polito, lou_breeze).
actor(barton_fink, steve_buscemi, chet).
actor(barton_fink, david_warrilow, garland_stanford).
actor(barton_fink, richard_portnow, detective_mastrionotti).
actor(barton_fink, christopher_murney, detective_deutsch).
actor(barton_fink, i_m_hobson, derek).
actress(barton_fink, meagen_fay, poppy_carnahan).
actor(barton_fink, lance_davis, richard_st_claire).
actor(barton_fink, harry_bugin, pete).
actor(barton_fink, anthony_gordon, maitre_d).
actor(barton_fink, jack_denbo, stagehand).
actor(barton_fink, max_grod_nchik, clapper_boy).
actor(barton_fink, robert_beecher, referee).
actor(barton_fink, darwyn_swalve, wrestler).
actress(barton_fink, gayle_vance, geisler_s_secretary).
actor(barton_fink, johnny_judkins, sailor).
actress(barton_fink, jana_marie_hupp, uso_girl).
actress(barton_fink, isabelle_townsend, beauty).
actor(barton_fink, william_preston_robertson, voice).

movie(the_big_lebowski, 1998).
director(the_big_lebowski, joel_coen).
actor(the_big_lebowski, jeff_bridges, jeffrey_lebowski__the_dude).
actor(the_big_lebowski, john_goodman, walter_sobchak).
actress(the_big_lebowski, julianne_moore, maude_lebowski).
actor(the_big_lebowski, steve_buscemi, theodore_donald_donny_kerabatsos).
actor(the_big_lebowski, david_huddleston, jeffrey_lebowski__the_big_lebowski).
actor(the_big_lebowski, philip_seymour_hoffman, brandt).
actress(the_big_lebowski, tara_reid, bunny_lebowski).
actor(the_big_lebowski, philip_moon, woo_treehorn_thug).
actor(the_big_lebowski, mark_pellegrino, blond_treehorn_thug).
actor(the_big_lebowski, peter_stormare, uli_kunkel_nihilist_1__karl_hungus).
actor(the_big_lebowski, flea, nihilist_2).
actor(the_big_lebowski, torsten_voges, nihilist_3).
actor(the_big_lebowski, jimmie_dale_gilmore, smokey).
actor(the_big_lebowski, jack_kehler, marty).
actor(the_big_lebowski, john_turturro, jesus_quintana).
actor(the_big_lebowski, james_g_hoosier, liam_o_brien).
actor(the_big_lebowski, carlos_leon, maude_s_thug).
actor(the_big_lebowski, terrence_burton, maude_s_thug).
actor(the_big_lebowski, richard_gant, older_cop).
actor(the_big_lebowski, christian_clemenson, younger_cop).
actor(the_big_lebowski, dom_irrera, tony_the_chauffeur).
actor(the_big_lebowski, g_rard_l_heureux, lebowski_s_chauffeur).
actor(the_big_lebowski, david_thewlis, knox_harrington).
actress(the_big_lebowski, lu_elrod, coffee_shop_waitress).
actor(the_big_lebowski, mike_gomez, auto_circus_cop).
actor(the_big_lebowski, peter_siragusa, gary_the_bartender).
actor(the_big_lebowski, sam_elliott, the_stranger).
actor(the_big_lebowski, marshall_manesh, doctor).
actor(the_big_lebowski, harry_bugin, arthur_digby_sellers).
actor(the_big_lebowski, jesse_flanagan, little_larry_sellers).
actress(the_big_lebowski, irene_olga_l_pez, pilar_sellers_housekeeper).
actor(the_big_lebowski, luis_colina, corvette_owner).
actor(the_big_lebowski, ben_gazzara, jackie_treehorn).
actor(the_big_lebowski, leon_russom, malibu_police_chief).
actor(the_big_lebowski, ajgie_kirkland, cab_driver).
actor(the_big_lebowski, jon_polito, da_fino).
actress(the_big_lebowski, aimee_mann, nihilist_woman).
actor(the_big_lebowski, jerry_haleva, saddam_hussein).
actress(the_big_lebowski, jennifer_lamb, pancake_waitress).
actor(the_big_lebowski, warren_keith, funeral_director).
actress(the_big_lebowski, wendy_braun, chorine_dancer).
actress(the_big_lebowski, asia_carrera, sherry_in_logjammin).
actress(the_big_lebowski, kiva_dawson, dancer).
actress(the_big_lebowski, robin_jones, checker_at_ralph_s).
actor(the_big_lebowski, paris_themmen, '').

movie(blade_runner, 1997).
director(blade_runner, joseph_d_kucan).
actor(blade_runner, martin_azarow, dino_klein).
actor(blade_runner, lloyd_bell, additional_voices).
actor(blade_runner, mark_benninghoffen, ray_mccoy).
actor(blade_runner, warren_burton, runciter).
actress(blade_runner, gwen_castaldi, dispatcher_and_newscaster).
actress(blade_runner, signy_coleman, dektora).
actor(blade_runner, gary_columbo, general_doll).
actor(blade_runner, jason_cottle, luthur_lance_photographer).
actor(blade_runner, timothy_dang, izo).
actor(blade_runner, gerald_deloff, additional_voices).
actress(blade_runner, lisa_edelstein, crystal_steele).
actor(blade_runner, gary_l_freeman, additional_voices).
actor(blade_runner, jeff_garlin, lieutenant_edison_guzza).
actor(blade_runner, eric_gooch, additional_voices).
actor(blade_runner, javier_grajeda, gaff).
actor(blade_runner, mike_grayford, additional_voices).
actress(blade_runner, gloria_hoffmann, mia).
actor(blade_runner, james_hong, dr_chew).
actress(blade_runner, kia_huntzinger, additional_voices).
actor(blade_runner, anthony_izzo, officer_leary).
actor(blade_runner, brion_james, leon).
actress(blade_runner, shelly_johnson, additional_voices).
actor(blade_runner, terry_jourden, spencer_grigorian).
actor(blade_runner, jerry_kernion, holloway).
actor(blade_runner, joseph_d_kucan, crazylegs_larry).
actor(blade_runner, jerry_lan, murray).
actor(blade_runner, michael_b_legg, additional_voices).
actor(blade_runner, demarlo_lewis, additional_voices).
actor(blade_runner, tse_cheng_lo, additional_voices).
actress(blade_runner, etsuko_mader, additional_voices).
actor(blade_runner, mohanned_mansour, additional_voices).
actress(blade_runner, karen_maruyama, fish_dealer).
actor(blade_runner, michael_mcshane, marcus_eisenduller).
actor(blade_runner, alexander_mervin, sadik).
actor(blade_runner, tony_mitch, governor_kolvig).
actor(blade_runner, toru_nagai, howie_lee).
actor(blade_runner, dwight_k_okahara, additional_voices).
actor(blade_runner, gerald_okamura, zuben).
actor(blade_runner, bruno_oliver, gordo_frizz).
actress(blade_runner, pauley_perrette, lucy_devlin).
actor(blade_runner, mark_rolston, clovis).
actor(blade_runner, stephen_root, early_q).
actor(blade_runner, william_sanderson, j_f_sebastian).
actor(blade_runner, vincent_schiavelli, bullet_bob).
actress(blade_runner, rosalyn_sidewater, isabella).
actor(blade_runner, ron_snow, blimp_announcer).
actor(blade_runner, stephen_sorrentino, shoeshine_man_hasan).
actress(blade_runner, jessica_straus, answering_machine_female_announcer).
actress(blade_runner, melonie_sung, additional_voices).
actor(blade_runner, iqbal_theba, moraji).
actress(blade_runner, myriam_tubert, insect_dealer).
actor(blade_runner, joe_turkel, eldon_tyrell).
actor(blade_runner, bill_wade, hanoi).
actor(blade_runner, jim_walls, additional_voices).
actress(blade_runner, sandra_wang, additional_voices).
actor(blade_runner, marc_worden, baker).
actress(blade_runner, sean_young, rachael).
actor(blade_runner, joe_tippy_zeoli, officer_grayford).

movie(blood_simple, 1984).
director(blood_simple, ethan_coen).
director(blood_simple, joel_coen).
actor(blood_simple, john_getz, ray).
actress(blood_simple, frances_mcdormand, abby).
actor(blood_simple, dan_hedaya, julian_marty).
actor(blood_simple, m_emmet_walsh, loren_visser_private_detective).
actor(blood_simple, samm_art_williams, meurice).
actress(blood_simple, deborah_neumann, debra).
actress(blood_simple, raquel_gavia, landlady).
actor(blood_simple, van_brooks, man_from_lubbock).
actor(blood_simple, se_or_marco, mr_garcia).
actor(blood_simple, william_creamer, old_cracker).
actor(blood_simple, loren_bivens, strip_bar_exhorter).
actor(blood_simple, bob_mcadams, strip_bar_exhorter).
actress(blood_simple, shannon_sedwick, stripper).
actress(blood_simple, nancy_finger, girl_on_overlook).
actor(blood_simple, william_preston_robertson, radio_evangelist).
actress(blood_simple, holly_hunter, helene_trend).
actor(blood_simple, barry_sonnenfeld, marty_s_vomiting).

movie(the_cotton_club, 1984).
director(the_cotton_club, francis_ford_coppola).
actor(the_cotton_club, richard_gere, michael_dixie_dwyer).
actor(the_cotton_club, gregory_hines, sandman_williams).
actress(the_cotton_club, diane_lane, vera_cicero).
actress(the_cotton_club, lonette_mckee, lila_rose_oliver).
actor(the_cotton_club, bob_hoskins, owney_madden).
actor(the_cotton_club, james_remar, dutch_schultz).
actor(the_cotton_club, nicolas_cage, vincent_dwyer).
actor(the_cotton_club, allen_garfield, abbadabba_berman).
actor(the_cotton_club, fred_gwynne, frenchy_demange).
actress(the_cotton_club, gwen_verdon, tish_dwyer).
actress(the_cotton_club, lisa_jane_persky, frances_flegenheimer).
actor(the_cotton_club, maurice_hines, clay_williams).
actor(the_cotton_club, julian_beck, sol_weinstein).
actress(the_cotton_club, novella_nelson, madame_st_clair).
actor(the_cotton_club, laurence_fishburne, bumpy_rhodes).
actor(the_cotton_club, john_p_ryan, joe_flynn).
actor(the_cotton_club, tom_waits, irving_stark).
actor(the_cotton_club, ron_karabatsos, mike_best).
actor(the_cotton_club, glenn_withrow, ed_popke).
actress(the_cotton_club, jennifer_grey, patsy_dwyer).
actress(the_cotton_club, wynonna_smith, winnie_williams).
actress(the_cotton_club, thelma_carpenter, norma_williams).
actor(the_cotton_club, charles_honi_coles, suger_coates).
actor(the_cotton_club, larry_marshall, cab_calloway_minnie_the_moocher__lady_with_the_fan_and_jitterbug_sung_by).
actor(the_cotton_club, joe_dallesandro, charles_lucky_luciano).
actor(the_cotton_club, ed_o_ross, monk).
actor(the_cotton_club, frederick_downs_jr, sullen_man).
actress(the_cotton_club, diane_venora, gloria_swanson).
actor(the_cotton_club, tucker_smallwood, kid_griffin).
actor(the_cotton_club, woody_strode, holmes).
actor(the_cotton_club, bill_graham, j_w).
actor(the_cotton_club, dayton_allen, solly).
actor(the_cotton_club, kim_chan, ling).
actor(the_cotton_club, ed_rowan, messiah).
actor(the_cotton_club, leonard_termo, danny).
actor(the_cotton_club, george_cantero, vince_hood).
actor(the_cotton_club, brian_tarantina, vince_hood).
actor(the_cotton_club, bruce_macvittie, vince_hood).
actor(the_cotton_club, james_russo, vince_hood).
actor(the_cotton_club, giancarlo_esposito, bumpy_hood).
actor(the_cotton_club, bruce_hubbard, bumpy_hood).
actor(the_cotton_club, rony_clanton, caspar_holstein).
actor(the_cotton_club, damien_leake, bub_jewett).
actor(the_cotton_club, bill_cobbs, big_joe_ison).
actor(the_cotton_club, joe_lynn, marcial_flores).
actor(the_cotton_club, oscar_barnes, spanish_henry).
actor(the_cotton_club, ed_zang, hotel_clerk).
actress(the_cotton_club, sandra_beall, myrtle_fay).
actor(the_cotton_club, zane_mark, duke_ellington).
actor(the_cotton_club, tom_signorelli, butch_murdock).
actor(the_cotton_club, paul_herman, policeman_1).
actor(the_cotton_club, randle_mell, policeman_2).
actor(the_cotton_club, steve_vignari, trigger_mike_coppola).
actress(the_cotton_club, susan_mechsner, gypsie).
actor(the_cotton_club, gregory_rozakis, charlie_chaplin).
actor(the_cotton_club, marc_coppola, ted_husing).
actress(the_cotton_club, norma_jean_darden, elda_webb).
actor(the_cotton_club, robert_earl_jones, stage_door_joe).
actor(the_cotton_club, vincent_jerosa, james_cagney).
actress(the_cotton_club, rosalind_harris, fanny_brice).
actor(the_cotton_club, steve_cafiso, child_in_street).
actor(the_cotton_club, john_cafiso, child_in_street).
actress(the_cotton_club, sofia_coppola, child_in_street).
actress(the_cotton_club, ninon_digiorgio, child_in_street).
actress(the_cotton_club, daria_hines, child_in_street).
actress(the_cotton_club, patricia_letang, child_in_street).
actor(the_cotton_club, christopher_lewis, child_in_street).
actress(the_cotton_club, danielle_osborne, child_in_street).
actor(the_cotton_club, jason_papalardo, child_in_street).
actor(the_cotton_club, demetrius_pena, child_in_street).
actress(the_cotton_club, priscilla_baskerville, creole_love_call_sung_by).
actress(the_cotton_club, ethel_beatty, bandana_babies_lead_vocal_dancer).
actress(the_cotton_club, sydney_goldsmith, barbecue_bess_sung_by).
actor(the_cotton_club, james_buster_brown, hoofer).
actor(the_cotton_club, ralph_brown, hoofer).
actor(the_cotton_club, harold_cromer, hoofer).
actor(the_cotton_club, bubba_gaines, hoofer).
actor(the_cotton_club, george_hillman, hoofer).
actor(the_cotton_club, henry_phace_roberts, hoofer).
actor(the_cotton_club, howard_sandman_sims, hoofer).
actor(the_cotton_club, jimmy_slyde, hoofer).
actor(the_cotton_club, henry_letang, hoofer).
actor(the_cotton_club, charles_young, hoofer).
actor(the_cotton_club, skip_cunningham, tip_tap__toe).
actor(the_cotton_club, luther_fontaine, tip_tap__toe).
actor(the_cotton_club, jan_mickens, tip_tap__toe).
actress(the_cotton_club, lydia_abarca, dancer).
actress(the_cotton_club, sarita_allen, dancer).
actress(the_cotton_club, tracey_bass, dancer).
actress(the_cotton_club, jacquelyn_bird, dancer).
actress(the_cotton_club, shirley_black_brown, dancer).
actress(the_cotton_club, jhoe_breedlove, dancer).
actor(the_cotton_club, lester_brown, dancer).
actress(the_cotton_club, leslie_caldwell, dancer).
actress(the_cotton_club, melanie_caldwell, dancer).
actor(the_cotton_club, benny_clorey, dancer).
actress(the_cotton_club, sheri_cowart, dancer).
actress(the_cotton_club, karen_dibianco, dancer).
actress(the_cotton_club, cisco_drayton, dancer).
actress(the_cotton_club, anne_duquesnay, dancer).
actress(the_cotton_club, carla_earle, dancer).
actress(the_cotton_club, wendy_edmead, dancer).
actress(the_cotton_club, debbie_fitts, dancer).
actor(the_cotton_club, ruddy_l_garner, dancer).
actress(the_cotton_club, ruthanna_graves, dancer).
actress(the_cotton_club, terri_griffin, dancer).
actress(the_cotton_club, robin_harmon, dancer).
actress(the_cotton_club, jackee_harree, dancer).
actress(the_cotton_club, sonya_hensley, dancer).
actor(the_cotton_club, dave_jackson, dancer).
actress(the_cotton_club, gail_kendricks, dancer).
actress(the_cotton_club, christina_kumi_kimball, dancer).
actress(the_cotton_club, mary_beth_kurdock, dancer).
actor(the_cotton_club, alde_lewis, dancer).
actress(the_cotton_club, paula_lynn, dancer).
actor(the_cotton_club, bernard_manners, dancer).
actor(the_cotton_club, bernard_marsh, dancer).
actor(the_cotton_club, david_mcharris, dancer).
actress(the_cotton_club, delores_mcharris, dancer).
actress(the_cotton_club, vody_najac, dancer).
actress(the_cotton_club, vya_negromonte, dancer).
actress(the_cotton_club, alice_anne_oates, dancer).
actress(the_cotton_club, anne_palmer, dancer).
actress(the_cotton_club, julie_pars, dancer).
actress(the_cotton_club, antonia_pettiford, dancer).
actress(the_cotton_club, valarie_pettiford, dancer).
actress(the_cotton_club, janet_powell, dancer).
actress(the_cotton_club, renee_rodriguez, dancer).
actress(the_cotton_club, tracey_ross, dancer).
actress(the_cotton_club, kiki_shepard, dancer).
actor(the_cotton_club, gary_thomas, dancer).
actor(the_cotton_club, mario_van_peebles, dancer).
actress(the_cotton_club, rima_vetter, dancer).
actress(the_cotton_club, karen_wadkins, dancer).
actor(the_cotton_club, ivery_wheeler, dancer).
actor(the_cotton_club, donald_williams, dancer).
actress(the_cotton_club, alexis_wilson, dancer).
actor(the_cotton_club, george_coutoupis, gangster).
actor(the_cotton_club, nicholas_j_giangiulio, screen_test_thug).
actress(the_cotton_club, suzanne_kaaren, the_duchess_of_park_avenue).
actor(the_cotton_club, mark_margolis, gunman_sooting_cage_s_character).
actor(the_cotton_club, kirk_taylor, cotton_club_waiter).
actor(the_cotton_club, stan_tracy, legs_diamond_s_bodyguard).
actor(the_cotton_club, rick_washburn, hitman).

movie(cq, 2001).
director(cq, roman_coppola).
actor(cq, jeremy_davies, paul).
actress(cq, angela_lindvall, dragonfly_valentine).
actress(cq, lodie_bouchez, marlene).
actor(cq, g_rard_depardieu, andrezej).
actor(cq, giancarlo_giannini, enzo).
actor(cq, massimo_ghini, fabrizio).
actor(cq, jason_schwartzman, felix_demarco).
actor(cq, billy_zane, mr_e).
actor(cq, john_phillip_law, chairman).
actor(cq, silvio_muccino, pippo).
actor(cq, dean_stockwell, dr_ballard).
actress(cq, natalia_vodianova, brigit).
actor(cq, bernard_verley, trailer_voiceover_actor).
actor(cq, l_m_kit_carson, fantasy_critic).
actor(cq, chris_bearne, fantasy_critic).
actor(cq, jean_paul_scarpitta, fantasy_critic).
actor(cq, nicolas_saada, fantasy_critic).
actor(cq, remi_fourquin, fantasy_critic).
actor(cq, jean_claude_schlim, fantasy_critic).
actress(cq, sascha_ley, fantasy_critic).
actor(cq, jacques_deglas, fantasy_critic).
actor(cq, gilles_soeder, fantasy_critic).
actor(cq, julian_nest, festival_critic).
actress(cq, greta_seacat, festival_critic).
actress(cq, barbara_sarafian, festival_critic).
actor(cq, leslie_woodhall, board_member).
actor(cq, jean_baptiste_kremer, board_member).
actor(cq, franck_sasonoff, angry_man_at_riots).
actor(cq, jean_fran_ois_wolff, party_man).
actor(cq, eric_connor, long_haired_actor_at_party).
actress(cq, diana_gartner, cute_model_at_party).
actress(cq, st_phanie_gesnel, actress_at_party).
actor(cq, fr_d_ric_de_brabant, steward).
actor(cq, shawn_mortensen, revolutionary_guard).
actor(cq, matthieu_tonetti, revolutionary_guard).
actress(cq, ann_maes, vampire_actress).
actress(cq, gintare_parulyte, vampire_actress).
actress(cq, caroline_lies, vampire_actress).
actress(cq, stoyanka_tanya_gospodinova, vampire_actress).
actress(cq, magali_dahan, vampire_actress).
actress(cq, natalie_broker, vampire_actress).
actress(cq, wanda_perdelwitz, vampire_actress).
actor(cq, mark_thompson_ashworth, lead_ghoul).
actor(cq, pieter_riemens, assistant_director).
actress(cq, federica_citarella, talkative_girl).
actor(cq, andrea_cormaci, soldier_boy).
actress(cq, corinne_terenzi, teen_lover).
actress(cq, sofia_coppola, enzo_s_mistress).
actor(cq, emidio_la_vella, italian_actor).
actor(cq, massimo_schina, friendly_guy_at_party).
actress(cq, caroline_colombini, girl_in_miniskirt).
actress(cq, rosa_pianeta, woman_in_fiat).
actor(cq, christophe_chrompin, jealous_boyfriend).
actor(cq, romain_duris, hippie_filmmaker).
actor(cq, chris_anthony, second_assistant_director).
actor(cq, dean_tavoularis, man_at_screening).

movie(crimewave, 1985).
director(crimewave, sam_raimi).
actress(crimewave, louise_lasser, helene_trend).
actor(crimewave, paul_l_smith, faron_crush).
actor(crimewave, brion_james, arthur_coddish).
actress(crimewave, sheree_j_wilson, nancy).
actor(crimewave, edward_r_pressman, ernest_trend).
actor(crimewave, bruce_campbell, renaldo_the_heel).
actor(crimewave, reed_birney, vic_ajax).
actor(crimewave, richard_bright, officer_brennan).
actor(crimewave, antonio_fargas, blind_man).
actor(crimewave, hamid_dana, donald_odegard).
actor(crimewave, john_hardy, mr_yarman).
actor(crimewave, emil_sitka, colonel_rodgers).
actor(crimewave, hal_youngblood, jack_elroy).
actor(crimewave, sean_farley, jack_elroy_jr).
actor(crimewave, richard_demanincor, officer_garvey).
actress(crimewave, carrie_hall, cheap_dish).
actor(crimewave, wiley_harker, governor).
actor(crimewave, julius_harris, hardened_convict).
actor(crimewave, ralph_drischell, executioner).
actor(crimewave, robert_symonds, guard_1).
actor(crimewave, patrick_stack, guard_2).
actor(crimewave, philip_a_gillis, priest).
actress(crimewave, bridget_hoffman, nun).
actress(crimewave, ann_marie_gillis, nun).
actress(crimewave, frances_mcdormand, nun).
actress(crimewave, carol_brinn, old_woman).
actor(crimewave, matthew_taylor, muscleman).
actor(crimewave, perry_mallette, grizzled_veteran).
actor(crimewave, chuck_gaidica, weatherman).
actor(crimewave, jimmie_launce, announcer).
actor(crimewave, joseph_french, bandleader).
actor(crimewave, ted_raimi, waiter).
actor(crimewave, dennis_chaitlin, fat_waiter).
actor(crimewave, joel_coen, reporter_at_execution).
actress(crimewave, julie_harris, '').
actor(crimewave, dan_nelson, waiter).

movie(down_from_the_mountain, 2000).
director(down_from_the_mountain, nick_doob).
director(down_from_the_mountain, chris_hegedus).
director(down_from_the_mountain, d_a_pennebaker).
actress(down_from_the_mountain, evelyn_cox, herself).
actor(down_from_the_mountain, sidney_cox, himself).
actress(down_from_the_mountain, suzanne_cox, herself).
actor(down_from_the_mountain, willard_cox, himself).
actor(down_from_the_mountain, nathan_best, himself).
actor(down_from_the_mountain, issac_freeman, himself).
actor(down_from_the_mountain, robert_hamlett, himself).
actor(down_from_the_mountain, joseph_rice, himself).
actor(down_from_the_mountain, wilson_waters_jr, himself).
actor(down_from_the_mountain, john_hartford, himself).
actor(down_from_the_mountain, larry_perkins, himself).
actress(down_from_the_mountain, emmylou_harris, herself).
actor(down_from_the_mountain, chris_thomas_king, himself).
actress(down_from_the_mountain, alison_krauss, herself).
actor(down_from_the_mountain, colin_linden, himself).
actor(down_from_the_mountain, pat_enright, himself).
actor(down_from_the_mountain, gene_libbea, himself).
actor(down_from_the_mountain, alan_o_bryant, himself).
actor(down_from_the_mountain, roland_white, himself).
actress(down_from_the_mountain, hannah_peasall, herself).
actress(down_from_the_mountain, leah_peasall, herself).
actress(down_from_the_mountain, sarah_peasall, herself).
actor(down_from_the_mountain, ralph_stanley, himself).
actress(down_from_the_mountain, gillian_welch, herself).
actor(down_from_the_mountain, david_rawlings, himself).
actor(down_from_the_mountain, buck_white, himself).
actress(down_from_the_mountain, cheryl_white, herself).
actress(down_from_the_mountain, sharon_white, herself).
actor(down_from_the_mountain, barry_bales, house_band_bass).
actor(down_from_the_mountain, ron_block, house_band_banjo).
actor(down_from_the_mountain, mike_compton, house_band_mandolin).
actor(down_from_the_mountain, jerry_douglas, house_band_dobro).
actor(down_from_the_mountain, stuart_duncan, house_band_fiddle).
actor(down_from_the_mountain, chris_sharp, house_band_guitar).
actor(down_from_the_mountain, dan_tyminski, house_band_guitar).
actor(down_from_the_mountain, t_bone_burnett, himself).
actor(down_from_the_mountain, ethan_coen, himself).
actor(down_from_the_mountain, joel_coen, himself).
actress(down_from_the_mountain, holly_hunter, herself).
actor(down_from_the_mountain, tim_blake_nelson, himself).
actor(down_from_the_mountain, billy_bob_thornton, audience_member).
actor(down_from_the_mountain, wes_motley, audience_member).
actress(down_from_the_mountain, tamara_trexler, audience_member).

movie(fargo, 1996).
director(fargo, ethan_coen).
director(fargo, joel_coen).
actor(fargo, william_h_macy, jerry_lundegaard).
actor(fargo, steve_buscemi, carl_showalter).
actor(fargo, peter_stormare, gaear_grimsrud).
actress(fargo, kristin_rudr_d, jean_lundegaard).
actor(fargo, harve_presnell, wade_gustafson).
actor(fargo, tony_denman, scotty_lundegaard).
actor(fargo, gary_houston, irate_customer).
actress(fargo, sally_wingert, irate_customer_s_wife).
actor(fargo, kurt_schweickhardt, car_salesman).
actress(fargo, larissa_kokernot, hooker_1).
actress(fargo, melissa_peterman, hooker_2).
actor(fargo, steve_reevis, shep_proudfoot).
actor(fargo, warren_keith, reilly_diefenbach).
actor(fargo, steve_edelman, morning_show_host).
actress(fargo, sharon_anderson, morning_show_hostess).
actor(fargo, larry_brandenburg, stan_grossman).
actor(fargo, james_gaulke, state_trooper).
actor(fargo, j_todd_anderson, victim_in_the_field).
actress(fargo, michelle_suzanne_ledoux, victim_in_car).
actress(fargo, frances_mcdormand, marge_gunderson).
actor(fargo, john_carroll_lynch, norm_gunderson).
actor(fargo, bruce_bohne, lou).
actress(fargo, petra_boden, cashier).
actor(fargo, steve_park, mike_yanagita).
actor(fargo, wayne_a_evenson, customer).
actor(fargo, cliff_rakerd, officer_olson).
actress(fargo, jessica_shepherd, hotel_clerk).
actor(fargo, peter_schmitz, airport_lot_attendant).
actor(fargo, steven_i_schafer, mechanic).
actress(fargo, michelle_hutchison, escort).
actor(fargo, david_s_lomax, man_in_hallway).
actor(fargo, jos_feliciano, himself).
actor(fargo, bix_skahill, night_parking_attendant).
actor(fargo, bain_boehlke, mr_mohra).
actress(fargo, rose_stockton, valerie).
actor(fargo, robert_ozasky, bismarck_cop_1).
actor(fargo, john_bandemer, bismarck_cop_2).
actor(fargo, don_wescott, bark_beetle_narrator).
actor(fargo, bruce_campbell, soap_opera_actor).
actor(fargo, clifford_nelson, heavyset_man_in_bar).

movie(the_firm, 1993).
director(the_firm, sydney_pollack).
actor(the_firm, tom_cruise, mitch_mcdeere).
actress(the_firm, jeanne_tripplehorn, abby_mcdeere).
actor(the_firm, gene_hackman, avery_tolar).
actor(the_firm, hal_holbrook, oliver_lambert).
actor(the_firm, terry_kinney, lamar_quinn).
actor(the_firm, wilford_brimley, william_devasher).
actor(the_firm, ed_harris, wayne_tarrance).
actress(the_firm, holly_hunter, tammy_hemphill).
actor(the_firm, david_strathairn, ray_mcdeere).
actor(the_firm, gary_busey, eddie_lomax).
actor(the_firm, steven_hill, f_denton_voyles).
actor(the_firm, tobin_bell, the_nordic_man).
actress(the_firm, barbara_garrick, kay_quinn).
actor(the_firm, jerry_hardin, royce_mcknight).
actor(the_firm, paul_calderon, thomas_richie).
actor(the_firm, jerry_weintraub, sonny_capps).
actor(the_firm, sullivan_walker, barry_abanks).
actress(the_firm, karina_lombard, young_woman_on_beach).
actress(the_firm, margo_martindale, nina_huff).
actor(the_firm, john_beal, nathan_locke).
actor(the_firm, dean_norris, the_squat_man).
actor(the_firm, lou_walker, frank_mulholland).
actress(the_firm, debbie_turner, rental_agent).
actor(the_firm, tommy_cresswell, wally_hudson).
actor(the_firm, david_a_kimball, randall_dunbar).
actor(the_firm, don_jones, attorney).
actor(the_firm, michael_allen, attorney).
actor(the_firm, levi_frazier_jr, restaurant_waiter).
actor(the_firm, brian_casey, telephone_installer).
actor(the_firm, reverend_william_j_parham, minister).
actor(the_firm, victor_nelson, cafe_waiter).
actor(the_firm, richard_ranta, congressman_billings).
actress(the_firm, janie_paris, madge).
actor(the_firm, frank_crawford, judge).
actor(the_firm, bart_whiteman, dutch).
actor(the_firm, david_dwyer, prison_guard).
actor(the_firm, mark_w_johnson, fbi_agent).
actor(the_firm, jerry_chipman, fbi_agent).
actor(the_firm, jimmy_lackie, technician).
actor(the_firm, afemo_omilami, cotton_truck_driver).
actor(the_firm, clint_smith, cotton_truck_driver).
actress(the_firm, susan_elliott, river_museum_guide).
actress(the_firm, erin_branham, river_museum_guide).
actor(the_firm, ed_connelly, pilot).
actress(the_firm, joey_anderson, ruth).
actress(the_firm, deborah_thomas, quinns_maid).
actor(the_firm, tommy_matthews, elvis_aaron_hemphill).
actor(the_firm, chris_schadrack, lawyer_recruiter).
actor(the_firm, buck_ford, lawyer_recruiter).
actor(the_firm, jonathan_kaplan, lawyer_recruiter).
actress(the_firm, rebecca_glenn, young_woman_at_patio_bar).
actress(the_firm, terri_welles, woman_dancing_with_avery).
actor(the_firm, greg_goossen, vietnam_veteran).
actress(the_firm, jeane_aufdenberg, car_rental_agent).
actor(the_firm, william_r_booth, seaplane_pilot).
actor(the_firm, ollie_nightingale, restaurant_singer).
actor(the_firm, teenie_hodges, restaurant_lead_guitarist).
actor(the_firm, little_jimmy_king, memphis_street_musician).
actor(the_firm, james_white, singer_at_hyatt).
actor(the_firm, shan_brisendine, furniture_mover).
actor(the_firm, harry_dach, garbage_truck_driver).
actress(the_firm, julia_hayes, girl_in_bar).
actor(the_firm, tom_mccrory, associate).
actor(the_firm, paul_sorvino, tommie_morolto).
actor(the_firm, joe_viterelli, joey_morolto).

movie(frankenweenie, 1984).
director(frankenweenie, tim_burton).
actress(frankenweenie, shelley_duvall, susan_frankenstein).
actor(frankenweenie, daniel_stern, ben_frankenstein).
actor(frankenweenie, barret_oliver, victor_frankenstein).
actor(frankenweenie, joseph_maher, mr_chambers).
actress(frankenweenie, roz_braverman, mrs_epstein).
actor(frankenweenie, paul_bartel, mr_walsh).
actress(frankenweenie, sofia_coppola, anne_chambers).
actor(frankenweenie, jason_hervey, frank_dale).
actor(frankenweenie, paul_c_scott, mike_anderson).
actress(frankenweenie, helen_boll, mrs_curtis).
actor(frankenweenie, sparky, sparky).
actor(frankenweenie, rusty_james, raymond).

movie(ghost_busters, 1984).
director(ghost_busters, ivan_reitman).
actor(ghost_busters, bill_murray, dr_peter_venkman).
actor(ghost_busters, dan_aykroyd, dr_raymond_stantz).
actress(ghost_busters, sigourney_weaver, dana_barrett).
actor(ghost_busters, harold_ramis, dr_egon_spengler).
actor(ghost_busters, rick_moranis, louis_tully).
actress(ghost_busters, annie_potts, janine_melnitz).
actor(ghost_busters, william_atherton, walter_peck_wally_wick).
actor(ghost_busters, ernie_hudson, winston_zeddmore).
actor(ghost_busters, david_margulies, mayor).
actor(ghost_busters, steven_tash, male_student).
actress(ghost_busters, jennifer_runyon, female_student).
actress(ghost_busters, slavitza_jovan, gozer).
actor(ghost_busters, michael_ensign, hotel_manager).
actress(ghost_busters, alice_drummond, librarian).
actor(ghost_busters, jordan_charney, dean_yeager).
actor(ghost_busters, timothy_carhart, violinist).
actor(ghost_busters, john_rothman, library_administrator).
actor(ghost_busters, tom_mcdermott, archbishop).
actor(ghost_busters, roger_grimsby, himself).
actor(ghost_busters, larry_king, himself).
actor(ghost_busters, joe_franklin, himself).
actor(ghost_busters, casey_kasem, himself).
actor(ghost_busters, john_ring, fire_commissioner).
actor(ghost_busters, norman_matlock, police_commissioner).
actor(ghost_busters, joe_cirillo, police_captain).
actor(ghost_busters, joe_schmieg, police_seargeant).
actor(ghost_busters, reginald_veljohnson, jail_guard).
actress(ghost_busters, rhoda_gemignani, real_estate_woman).
actor(ghost_busters, murray_rubin, man_at_elevator).
actor(ghost_busters, larry_dilg, con_edison_man).
actor(ghost_busters, danny_stone, coachman).
actress(ghost_busters, patty_dworkin, woman_at_party).
actress(ghost_busters, jean_kasem, tall_woman_at_party).
actor(ghost_busters, lenny_del_genio, doorman).
actress(ghost_busters, frances_e_nealy, chambermaid).
actor(ghost_busters, sam_moses, hot_dog_vendor).
actor(ghost_busters, christopher_wynkoop, tv_reporter).
actor(ghost_busters, winston_may, businessman_in_cab).
actor(ghost_busters, tommy_hollis, mayor_s_aide).
actress(ghost_busters, eda_reiss_merin, louis_s_neighbor).
actor(ghost_busters, ric_mancini, policeman_at_apartment).
actress(ghost_busters, kathryn_janssen, mrs_van_hoffman).
actor(ghost_busters, stanley_grover, reporter).
actress(ghost_busters, carol_ann_henry, reporter).
actor(ghost_busters, james_hardie, reporter).
actress(ghost_busters, frances_turner, reporter).
actress(ghost_busters, nancy_kelly, reporter).
actor(ghost_busters, paul_trafas, ted_fleming).
actress(ghost_busters, cheryl_birchenfield, annette_fleming).
actress(ghost_busters, ruth_oliver, library_ghost).
actress(ghost_busters, kymberly_herrin, dream_ghost).
actor(ghost_busters, larry_bilzarian, prisoner).
actor(ghost_busters, matteo_cafiso, boy_at_hot_dog_stand).
actress(ghost_busters, paddi_edwards, gozer).
actress(ghost_busters, deborah_gibson, birthday_girl_in_tavern_on_the_green).
actor(ghost_busters, charles_levin, honeymooner).
actor(ghost_busters, joseph_marzano, man_in_taxi).
actor(ghost_busters, joe_medjuck, man_at_library).
actor(ghost_busters, frank_patton, city_hall_cop).
actor(ghost_busters, harrison_ray, terror_dog).
actor(ghost_busters, ivan_reitman, zuul_slimer).
actor(ghost_busters, mario_todisco, prisoner).
actor(ghost_busters, bill_walton, himself).

movie(girl_with_a_pearl_earring, 2003).
director(girl_with_a_pearl_earring, peter_webber).
actor(girl_with_a_pearl_earring, colin_firth, johannes_vermeer).
actress(girl_with_a_pearl_earring, scarlett_johansson, griet).
actor(girl_with_a_pearl_earring, tom_wilkinson, van_ruijven).
actress(girl_with_a_pearl_earring, judy_parfitt, maria_thins).
actor(girl_with_a_pearl_earring, cillian_murphy, pieter).
actress(girl_with_a_pearl_earring, essie_davis, catharina_vermeer).
actress(girl_with_a_pearl_earring, joanna_scanlan, tanneke).
actress(girl_with_a_pearl_earring, alakina_mann, cornelia_vermeer).
actor(girl_with_a_pearl_earring, chris_mchallem, griet_s_father).
actress(girl_with_a_pearl_earring, gabrielle_reidy, griet_s_mother).
actor(girl_with_a_pearl_earring, rollo_weeks, frans).
actress(girl_with_a_pearl_earring, anna_popplewell, maertge).
actress(girl_with_a_pearl_earring, ana_s_nepper, lisbeth).
actress(girl_with_a_pearl_earring, melanie_meyfroid, aleydis).
actor(girl_with_a_pearl_earring, nathan_nepper, johannes).
actress(girl_with_a_pearl_earring, lola_carpenter, baby_franciscus).
actress(girl_with_a_pearl_earring, charlotte_carpenter, baby_franciscus).
actress(girl_with_a_pearl_earring, olivia_chauveau, baby_franciscus).
actor(girl_with_a_pearl_earring, geoff_bell, paul_the_butcher).
actress(girl_with_a_pearl_earring, virginie_colin, emilie_van_ruijven).
actress(girl_with_a_pearl_earring, sarah_drews, van_ruijven_s_daughter).
actress(girl_with_a_pearl_earring, christelle_bulckaen, wet_nurse).
actor(girl_with_a_pearl_earring, john_mcenery, apothecary).
actress(girl_with_a_pearl_earring, gintare_parulyte, model).
actress(girl_with_a_pearl_earring, claire_johnston, white_haired_woman).
actor(girl_with_a_pearl_earring, marc_maes, old_gentleman).
actor(girl_with_a_pearl_earring, robert_sibenaler, priest).
actor(girl_with_a_pearl_earring, dustin_james, servant_1).
actor(girl_with_a_pearl_earring, joe_reavis, servant_2).
actor(girl_with_a_pearl_earring, martin_serene, sergeant).
actor(girl_with_a_pearl_earring, chris_kelly, gay_blade).
actor(girl_with_a_pearl_earring, leslie_woodhall, neighbour).

movie(the_godfather, 1972).
director(the_godfather, francis_ford_coppola).
actor(the_godfather, marlon_brando, don_vito_corleone).
actor(the_godfather, al_pacino, michael_corleone).
actor(the_godfather, james_caan, santino_sonny_corleone).
actor(the_godfather, richard_s_castellano, pete_clemenza).
actor(the_godfather, robert_duvall, tom_hagen).
actor(the_godfather, sterling_hayden, capt_mark_mccluskey).
actor(the_godfather, john_marley, jack_woltz).
actor(the_godfather, richard_conte, emilio_barzini).
actor(the_godfather, al_lettieri, virgil_sollozzo).
actress(the_godfather, diane_keaton, kay_adams).
actor(the_godfather, abe_vigoda, salvadore_sally_tessio).
actress(the_godfather, talia_shire, connie).
actor(the_godfather, gianni_russo, carlo_rizzi).
actor(the_godfather, john_cazale, fredo).
actor(the_godfather, rudy_bond, ottilio_cuneo).
actor(the_godfather, al_martino, johnny_fontane).
actress(the_godfather, morgana_king, mama_corleone).
actor(the_godfather, lenny_montana, luca_brasi).
actor(the_godfather, john_martino, paulie_gatto).
actor(the_godfather, salvatore_corsitto, amerigo_bonasera).
actor(the_godfather, richard_bright, al_neri).
actor(the_godfather, alex_rocco, moe_greene).
actor(the_godfather, tony_giorgio, bruno_tattaglia).
actor(the_godfather, vito_scotti, nazorine).
actress(the_godfather, tere_livrano, theresa_hagen).
actor(the_godfather, victor_rendina, philip_tattaglia).
actress(the_godfather, jeannie_linero, lucy_mancini).
actress(the_godfather, julie_gregg, sandra_corleone).
actress(the_godfather, ardell_sheridan, mrs_clemenza).
actress(the_godfather, simonetta_stefanelli, apollonia_vitelli_corleone).
actor(the_godfather, angelo_infanti, fabrizio).
actor(the_godfather, corrado_gaipa, don_tommasino).
actor(the_godfather, franco_citti, calo).
actor(the_godfather, saro_urz, vitelli).
actor(the_godfather, carmine_coppola, piano_player_in_montage_scene).
actor(the_godfather, gian_carlo_coppola, baptism_observer).
actress(the_godfather, sofia_coppola, michael_francis_rizzi).
actor(the_godfather, ron_gilbert, usher_in_bridal_party).
actor(the_godfather, anthony_gounaris, anthony_vito_corleone).
actor(the_godfather, joe_lo_grippo, sonny_s_bodyguard).
actor(the_godfather, sonny_grosso, cop_with_capt_mccluskey_outside_hospital).
actor(the_godfather, louis_guss, don_zaluchi_outspoken_don_at_the_peace_conference).
actor(the_godfather, randy_jurgensen, sonny_s_killer_1).
actor(the_godfather, tony_lip, wedding_guest).
actor(the_godfather, frank_macetta, '').
actor(the_godfather, lou_martini_jr, boy_at_wedding).
actor(the_godfather, father_joseph_medeglia, priest_at_baptism).
actor(the_godfather, rick_petrucelli, man_in_passenger_seat_when_michael_is_driven_to_the_hospital).
actor(the_godfather, burt_richards, floral_designer).
actor(the_godfather, sal_richards, drunk).
actor(the_godfather, tom_rosqui, rocco_lampone).
actor(the_godfather, frank_sivero, extra).
actress(the_godfather, filomena_spagnuolo, extra_at_wedding_scene).
actor(the_godfather, joe_spinell, willie_cicci).
actor(the_godfather, gabriele_torrei, enzo_robutti_the_baker).
actor(the_godfather, nick_vallelonga, wedding_party_guest).
actor(the_godfather, ed_vantura, wedding_guest).
actor(the_godfather, matthew_vlahakis, clemenza_s_son_pushing_toy_car_in_driveway).

movie(the_godfather_part_ii, 1974).
director(the_godfather_part_ii, francis_ford_coppola).
actor(the_godfather_part_ii, al_pacino, don_michael_corleone).
actor(the_godfather_part_ii, robert_duvall, tom_hagen).
actress(the_godfather_part_ii, diane_keaton, kay_corleone).
actor(the_godfather_part_ii, robert_de_niro, vito_corleone).
actor(the_godfather_part_ii, john_cazale, fredo_corleone).
actress(the_godfather_part_ii, talia_shire, connie_corleone).
actor(the_godfather_part_ii, lee_strasberg, hyman_roth).
actor(the_godfather_part_ii, michael_v_gazzo, frankie_pentangeli).
actor(the_godfather_part_ii, g_d_spradlin, sen_pat_geary).
actor(the_godfather_part_ii, richard_bright, al_neri).
actor(the_godfather_part_ii, gastone_moschin, don_fanucci).
actor(the_godfather_part_ii, tom_rosqui, rocco_lampone).
actor(the_godfather_part_ii, bruno_kirby, young_clemenza_peter).
actor(the_godfather_part_ii, frank_sivero, genco_abbandando).
actress(the_godfather_part_ii, francesca_de_sapio, young_mama_corleone).
actress(the_godfather_part_ii, morgana_king, older_carmella_mama_corleone).
actress(the_godfather_part_ii, marianna_hill, deanna_dunn_corleone).
actor(the_godfather_part_ii, leopoldo_trieste, signor_roberto_landlord).
actor(the_godfather_part_ii, dominic_chianese, johnny_ola).
actor(the_godfather_part_ii, amerigo_tot, busetta_michael_s_bodyguard).
actor(the_godfather_part_ii, troy_donahue, merle_johnson).
actor(the_godfather_part_ii, john_aprea, young_sal_tessio).
actor(the_godfather_part_ii, joe_spinell, willie_cicci).
actor(the_godfather_part_ii, james_caan, sonny_corleone_special_participation).
actor(the_godfather_part_ii, abe_vigoda, sal_tessio).
actress(the_godfather_part_ii, tere_livrano, theresa_hagen).
actor(the_godfather_part_ii, gianni_russo, carlo_rizzi).
actress(the_godfather_part_ii, maria_carta, signora_andolini_vito_s_mother).
actor(the_godfather_part_ii, oreste_baldini, young_vito_andolini).
actor(the_godfather_part_ii, giuseppe_sillato, don_francesco_ciccio).
actor(the_godfather_part_ii, mario_cotone, don_tommasino).
actor(the_godfather_part_ii, james_gounaris, anthony_vito_corleone).
actress(the_godfather_part_ii, fay_spain, mrs_marcia_roth).
actor(the_godfather_part_ii, harry_dean_stanton, fbi_man_1).
actor(the_godfather_part_ii, david_baker, fbi_man_2).
actor(the_godfather_part_ii, carmine_caridi, carmine_rosato).
actor(the_godfather_part_ii, danny_aiello, tony_rosato).
actor(the_godfather_part_ii, carmine_foresta, policeman).
actor(the_godfather_part_ii, nick_discenza, bartender).
actor(the_godfather_part_ii, father_joseph_medeglia, father_carmelo).
actor(the_godfather_part_ii, william_bowers, senate_committee_chairman).
actor(the_godfather_part_ii, joseph_della_sorte, michael_s_buttonman_1).
actor(the_godfather_part_ii, carmen_argenziano, michael_s_buttonman_2).
actor(the_godfather_part_ii, joe_lo_grippo, michael_s_buttonman_3).
actor(the_godfather_part_ii, ezio_flagello, impresario).
actor(the_godfather_part_ii, livio_giorgi, tenor_in_senza_mamma).
actress(the_godfather_part_ii, kathleen_beller, girl_in_senza_mamma).
actress(the_godfather_part_ii, saveria_mazzola, signora_colombo).
actor(the_godfather_part_ii, tito_alba, cuban_pres_fulgencio_batista).
actor(the_godfather_part_ii, johnny_naranjo, cuban_translator).
actress(the_godfather_part_ii, elda_maida, pentangeli_s_wife).
actor(the_godfather_part_ii, salvatore_po, vincenzo_pentangeli).
actor(the_godfather_part_ii, ignazio_pappalardo, mosca_assassin_in_sicily).
actor(the_godfather_part_ii, andrea_maugeri, strollo).
actor(the_godfather_part_ii, peter_lacorte, signor_abbandando).
actor(the_godfather_part_ii, vincent_coppola, street_vendor).
actor(the_godfather_part_ii, peter_donat, questadt).
actor(the_godfather_part_ii, tom_dahlgren, fred_corngold).
actor(the_godfather_part_ii, paul_b_brown, sen_ream).
actor(the_godfather_part_ii, phil_feldman, senator_1).
actor(the_godfather_part_ii, roger_corman, senator_2).
actress(the_godfather_part_ii, ivonne_coll, yolanda).
actor(the_godfather_part_ii, joe_de_nicola, attendant_at_brothel).
actor(the_godfather_part_ii, edward_van_sickle, ellis_island_doctor).
actress(the_godfather_part_ii, gabriella_belloni, ellis_island_nurse).
actor(the_godfather_part_ii, richard_watson, customs_official).
actress(the_godfather_part_ii, venancia_grangerard, cuban_nurse).
actress(the_godfather_part_ii, erica_yohn, governess).
actress(the_godfather_part_ii, theresa_tirelli, midwife).
actor(the_godfather_part_ii, roman_coppola, sonny_corleone_as_a_boy).
actress(the_godfather_part_ii, sofia_coppola, child_on_steamship_in_ny_harbor).
actor(the_godfather_part_ii, larry_guardino, vito_s_uncle).
actor(the_godfather_part_ii, gary_kurtz, photographer_in_court).
actress(the_godfather_part_ii, laura_lyons, '').
actress(the_godfather_part_ii, connie_mason, extra).
actor(the_godfather_part_ii, john_megna, young_hyman_roth).
actor(the_godfather_part_ii, frank_pesce, extra).
actress(the_godfather_part_ii, filomena_spagnuolo, extra_in_little_italy).

movie(the_godfather_part_iii, 1990).
director(the_godfather_part_iii, francis_ford_coppola).
actor(the_godfather_part_iii, al_pacino, don_michael_corleone).
actress(the_godfather_part_iii, diane_keaton, kay_adams_mitchelson).
actress(the_godfather_part_iii, talia_shire, connie_corleone_rizzi).
actor(the_godfather_part_iii, andy_garcia, don_vincent_vinnie_mancini_corleone).
actor(the_godfather_part_iii, eli_wallach, don_altobello).
actor(the_godfather_part_iii, joe_mantegna, joey_zasa).
actor(the_godfather_part_iii, george_hamilton, b_j_harrison).
actress(the_godfather_part_iii, bridget_fonda, grace_hamilton).
actress(the_godfather_part_iii, sofia_coppola, mary_corleone).
actor(the_godfather_part_iii, raf_vallone, cardinal_lamberto).
actor(the_godfather_part_iii, franc_d_ambrosio, anthony_vito_corleone_turiddu_sequence_cavalleria_rusticana).
actor(the_godfather_part_iii, donal_donnelly, archbishop_gilday).
actor(the_godfather_part_iii, richard_bright, al_neri).
actor(the_godfather_part_iii, helmut_berger, frederick_keinszig).
actor(the_godfather_part_iii, don_novello, dominic_abbandando).
actor(the_godfather_part_iii, john_savage, father_andrew_hagen).
actor(the_godfather_part_iii, franco_citti, calo).
actor(the_godfather_part_iii, mario_donatone, mosca).
actor(the_godfather_part_iii, vittorio_duse, don_tommasino).
actor(the_godfather_part_iii, enzo_robutti, don_licio_lucchesi).
actor(the_godfather_part_iii, michele_russo, spara).
actor(the_godfather_part_iii, al_martino, johnny_fontane).
actor(the_godfather_part_iii, robert_cicchini, lou_penning).
actor(the_godfather_part_iii, rogerio_miranda, twin_bodyguard_armand).
actor(the_godfather_part_iii, carlos_miranda, twin_bodyguard_francesco).
actor(the_godfather_part_iii, vito_antuofermo, anthony_the_ant_squigliaro_joey_zaza_s_bulldog).
actor(the_godfather_part_iii, robert_vento, father_john).
actor(the_godfather_part_iii, willie_brown, party_politician).
actress(the_godfather_part_iii, jeannie_linero, lucy_mancini).
actor(the_godfather_part_iii, remo_remotti, camerlengo_cardinal_cardinal__sistine).
actress(the_godfather_part_iii, jeanne_savarino_pesch, francesca_corleone).
actress(the_godfather_part_iii, janet_savarino_smith, kathryn_corleone).
actress(the_godfather_part_iii, tere_livrano, teresa_hagen).
actor(the_godfather_part_iii, carmine_caridi, albert_volpe).
actor(the_godfather_part_iii, don_costello, frank_romano).
actor(the_godfather_part_iii, al_ruscio, leo_cuneo).
actor(the_godfather_part_iii, mickey_knox, marty_parisi).
actor(the_godfather_part_iii, rick_aviles, mask_1).
actor(the_godfather_part_iii, michael_bowen, mask_2).
actor(the_godfather_part_iii, brett_halsey, douglas_michelson).
actor(the_godfather_part_iii, gabriele_torrei, enzo_the_baker).
actor(the_godfather_part_iii, john_abineri, hamilton_banker).
actor(the_godfather_part_iii, brian_freilino, stockholder).
actor(the_godfather_part_iii, gregory_corso, unruly_stockholder).
actor(the_godfather_part_iii, marino_mas, lupo).
actor(the_godfather_part_iii, dado_ruspoli, vanni).
actress(the_godfather_part_iii, valeria_sabel, sister_vincenza).
actor(the_godfather_part_iii, luigi_laezza, keinszig_killer).
actor(the_godfather_part_iii, beppe_pianviti, keinszig_killer).
actor(the_godfather_part_iii, santo_indelicato, guardia_del_corpo).
actor(the_godfather_part_iii, francesco_paolo_bellante, autista_di_don_tommasino).
actor(the_godfather_part_iii, paco_reconti, gesu).
actor(the_godfather_part_iii, mimmo_cuticchio, puppet_narrator).
actor(the_godfather_part_iii, richard_honigman, party_reporter).
actor(the_godfather_part_iii, nicky_blair, nicky_the_casino_host).
actor(the_godfather_part_iii, anthony_guidera, anthony_the_bodyguard).
actor(the_godfather_part_iii, frank_tarsia, frankie_the_bodyguard).
actress(the_godfather_part_iii, diane_agostini, woman_with_child_at_street_fair).
actress(the_godfather_part_iii, jessica_di_cicco, child).
actress(the_godfather_part_iii, catherine_scorsese, woman_in_cafe).
actress(the_godfather_part_iii, ida_bernardini, woman_in_cafe).
actor(the_godfather_part_iii, joe_drago, party_security).
actor(the_godfather_part_iii, david_hume_kennerly, party_photographer).
actor(the_godfather_part_iii, james_d_damiano, son_playing_soccer).
actor(the_godfather_part_iii, michael_boccio, father_of_soccer_player).
actor(the_godfather_part_iii, anton_coppola, conductor_sequence_cavalleria_rusticana).
actress(the_godfather_part_iii, elena_lo_forte, santuzza_played_by_sequence_cavalleria_rusticana).
actress(the_godfather_part_iii, madelyn_ren_e_monti, santuzza_sung_by_lola_sequence_cavalleria_rusticana).
actress(the_godfather_part_iii, corinna_vozza, lucia_sequence_cavalleria_rusticana).
actor(the_godfather_part_iii, angelo_romero, alfio_played_by_sequence_cavalleria_rusticana).
actor(the_godfather_part_iii, paolo_gavanelli, alfio_sung_by_sequence_cavalleria_rusticana).
actor(the_godfather_part_iii, salvatore_billa, hired_assassin).
actor(the_godfather_part_iii, sal_borgese, lucchesi_s_door_guard).
actor(the_godfather_part_iii, james_caan, sonny_corleone).
actor(the_godfather_part_iii, richard_s_castellano, peter_clemenza).
actor(the_godfather_part_iii, john_cazale, fredo_corleone).
actor(the_godfather_part_iii, tony_devon, mob_family_lawyer_at_the_church).
actor(the_godfather_part_iii, andrea_girolami, extra).
actress(the_godfather_part_iii, simonetta_stefanelli, apollonia_vitelli_corleone).
actor(the_godfather_part_iii, lee_strasberg, hyman_roth_stukowski).
actor(the_godfather_part_iii, f_x_vitolo, pasquale).

movie(groundhog_day, 1993).
director(groundhog_day, harold_ramis).
actor(groundhog_day, bill_murray, phil_connors).
actress(groundhog_day, andie_macdowell, rita).
actor(groundhog_day, chris_elliott, larry).
actor(groundhog_day, stephen_tobolowsky, ned_ryerson).
actor(groundhog_day, brian_doyle_murray, buster_green).
actress(groundhog_day, marita_geraghty, nancy_taylor).
actress(groundhog_day, angela_paton, mrs_lancaster).
actor(groundhog_day, rick_ducommun, gus).
actor(groundhog_day, rick_overton, ralph).
actress(groundhog_day, robin_duke, doris_the_waitress).
actress(groundhog_day, carol_bivins, anchorwoman).
actor(groundhog_day, willie_garson, kenny).
actor(groundhog_day, ken_hudson_campbell, man_in_hallway).
actor(groundhog_day, les_podewell, old_man).
actor(groundhog_day, rod_sell, groundhog_official).
actor(groundhog_day, tom_milanovich, state_trooper).
actor(groundhog_day, john_m_watson_sr, bartender).
actress(groundhog_day, peggy_roeder, piano_teacher).
actor(groundhog_day, harold_ramis, neurologist).
actor(groundhog_day, david_pasquesi, psychiatrist).
actor(groundhog_day, lee_r_sellars, cop).
actor(groundhog_day, chet_dubowski, felix_bank_guard).
actor(groundhog_day, doc_erickson, herman_bank_guard).
actress(groundhog_day, sandy_maschmeyer, phil_s_movie_date).
actress(groundhog_day, leighanne_o_neil, fan_on_street).
actress(groundhog_day, evangeline_binkley, jeopardy__viewer).
actor(groundhog_day, samuel_mages, jeopardy__viewer).
actor(groundhog_day, ben_zwick, jeopardy__viewer).
actress(groundhog_day, hynden_walch, debbie_kleiser).
actor(groundhog_day, michael_shannon, fred_kleiser).
actor(groundhog_day, timothy_hendrickson, bill_waiter).
actress(groundhog_day, martha_webster, alice_waitress).
actress(groundhog_day, angela_gollan, piano_student).
actor(groundhog_day, shaun_chaiyabhat, boy_in_tree).
actress(groundhog_day, dianne_b_shaw, e_r_nurse).
actress(groundhog_day, barbara_ann_grimes, flat_tire_lady).
actress(groundhog_day, ann_heekin, flat_tire_lady).
actress(groundhog_day, lucina_paquet, flat_tire_lady).
actress(groundhog_day, brenda_pickleman, buster_s_wife).
actress(groundhog_day, amy_murdoch, buster_s_daughter).
actor(groundhog_day, eric_saiet, buster_s_son).
actress(groundhog_day, lindsay_albert, woman_with_cigarette).
actor(groundhog_day, roger_adler, guitarist).
actor(groundhog_day, ben_a_fish, bassist).
actor(groundhog_day, don_riozz_mcnichols, drummer).
actor(groundhog_day, brian_willig, saxophonist).
actor(groundhog_day, richard_henzel, dj).
actor(groundhog_day, rob_riley, dj).
actor(groundhog_day, scooter, the_groundhog).
actor(groundhog_day, douglas_blakeslee, man_with_snow_shovel).
actress(groundhog_day, leslie_frates, herself__jeopardy__contestant).
actor(groundhog_day, mason_gamble, '').
actor(groundhog_day, simon_harvey, news_reporter).
actor(groundhog_day, grady_hutt, '').
actress(groundhog_day, regina_prokop, polka_dancer).
actor(groundhog_day, daniel_riggs, bachelor).
actor(groundhog_day, paul_terrien, groundhog_official).

movie(hail_caesar, 2016).
director(hail_caesar, ethan_coen).
director(hail_caesar, joel_coen).

movie(hearts_of_darkness_a_filmmaker_s_apocalypse, 1991).
director(hearts_of_darkness_a_filmmaker_s_apocalypse, fax_bahr).
director(hearts_of_darkness_a_filmmaker_s_apocalypse, eleanor_coppola).
director(hearts_of_darkness_a_filmmaker_s_apocalypse, george_hickenlooper).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, john_milius, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, sam_bottoms, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, marlon_brando, himself).
actress(hearts_of_darkness_a_filmmaker_s_apocalypse, colleen_camp, herself).
actress(hearts_of_darkness_a_filmmaker_s_apocalypse, eleanor_coppola, herself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, francis_ford_coppola, himself).
actress(hearts_of_darkness_a_filmmaker_s_apocalypse, gia_coppola, herself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, roman_coppola, himself).
actress(hearts_of_darkness_a_filmmaker_s_apocalypse, sofia_coppola, herself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, robert_de_niro, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, robert_duvall, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, laurence_fishburne, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, harrison_ford, '').
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, frederic_forrest, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, albert_hall, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, dennis_hopper, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, george_lucas, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, martin_sheen, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, g_d_spradlin, himself).
actor(hearts_of_darkness_a_filmmaker_s_apocalypse, orson_welles, himself_from_1938_radio_broadcast).

movie(the_hudsucker_proxy, 1994).
director(the_hudsucker_proxy, ethan_coen).
director(the_hudsucker_proxy, joel_coen).
actor(the_hudsucker_proxy, tim_robbins, norville_barnes).
actress(the_hudsucker_proxy, jennifer_jason_leigh, amy_archer).
actor(the_hudsucker_proxy, paul_newman, sidney_j_mussburger).
actor(the_hudsucker_proxy, charles_durning, waring_hudsucker).
actor(the_hudsucker_proxy, john_mahoney, chief_editor_manhattan_argus).
actor(the_hudsucker_proxy, jim_true_frost, buzz_the_elevator_operator).
actor(the_hudsucker_proxy, bill_cobbs, moses_the_clock_man).
actor(the_hudsucker_proxy, bruce_campbell, smitty_argus_reporter).
actor(the_hudsucker_proxy, harry_bugin, aloysius_mussburger_s_spy).
actor(the_hudsucker_proxy, john_seitz, bennie_the_cabbie).
actor(the_hudsucker_proxy, joe_grifasi, lou_the_cabbie).
actor(the_hudsucker_proxy, roy_brocksmith, board_member).
actor(the_hudsucker_proxy, john_wylie, board_member).
actor(the_hudsucker_proxy, i_m_hobson, board_member).
actor(the_hudsucker_proxy, gary_allen, board_member).
actor(the_hudsucker_proxy, john_scanlan, board_member).
actor(the_hudsucker_proxy, richard_woods, board_member).
actor(the_hudsucker_proxy, jerome_dempsey, board_member).
actor(the_hudsucker_proxy, peter_mcpherson, board_member).
actor(the_hudsucker_proxy, david_byrd, dr_hugo_bronfenbrenner).
actor(the_hudsucker_proxy, christopher_darga, mail_room_orienter).
actor(the_hudsucker_proxy, patrick_cranshaw, ancient_sorter).
actor(the_hudsucker_proxy, robert_weil, mail_room_boss).
actress(the_hudsucker_proxy, mary_lou_rosato, mussburger_s_secretary).
actor(the_hudsucker_proxy, ernest_sarracino, luigi_the_tailor).
actress(the_hudsucker_proxy, eleanor_glockner, mrs_mussburger).
actress(the_hudsucker_proxy, kathleen_perkins, mrs_braithwaite).
actor(the_hudsucker_proxy, joseph_marcus, sears_braithwaite_of_bullard).
actor(the_hudsucker_proxy, peter_gallagher, vic_tenetta_party_singer).
actor(the_hudsucker_proxy, noble_willingham, zebulon_cardoza).
actress(the_hudsucker_proxy, barbara_ann_grimes, mrs_cardoza).
actor(the_hudsucker_proxy, thom_noble, thorstenson_finlandson_finnish_stockholder).
actor(the_hudsucker_proxy, steve_buscemi, beatnik_barman_at_ann_s_440).
actor(the_hudsucker_proxy, william_duff_griffin, newsreel_scientist).
actress(the_hudsucker_proxy, anna_nicole_smith, za_za).
actress(the_hudsucker_proxy, pamela_everett, dream_dancer).
actor(the_hudsucker_proxy, arthur_bridgers, the_hula_hoop_kid).
actor(the_hudsucker_proxy, sam_raimi, hudsucker_brainstormer).
actor(the_hudsucker_proxy, john_cameron, hudsucker_brainstormer).
actor(the_hudsucker_proxy, skipper_duke, mr_grier).
actor(the_hudsucker_proxy, jay_kapner, mr_levin).
actor(the_hudsucker_proxy, jon_polito, mr_bumstead).
actor(the_hudsucker_proxy, richard_whiting, ancient_puzzler).
actress(the_hudsucker_proxy, linda_mccoy, coffee_shop_waitress).
actor(the_hudsucker_proxy, stan_adams, emcee).
actor(the_hudsucker_proxy, john_goodman, rockwell_newsreel_anouncer).
actress(the_hudsucker_proxy, joanne_pankow, newsreel_secretary).
actor(the_hudsucker_proxy, mario_todisco, norville_s_goon).
actor(the_hudsucker_proxy, colin_fickes, newsboy).
actor(the_hudsucker_proxy, dick_sasso, drunk_in_alley).
actor(the_hudsucker_proxy, jesse_brewer, mailroom_screamer).
actor(the_hudsucker_proxy, philip_loch, mailroom_screamer).
actor(the_hudsucker_proxy, stan_lichtenstein, mailroom_screamer).
actor(the_hudsucker_proxy, todd_alcott, mailroom_screamer).
actor(the_hudsucker_proxy, ace_o_connell, mailroom_screamer).
actor(the_hudsucker_proxy, richard_schiff, mailroom_screamer).
actor(the_hudsucker_proxy, frank_jeffries, mailroom_screamer).
actor(the_hudsucker_proxy, lou_criscuolo, mailroom_screamer).
actor(the_hudsucker_proxy, michael_earl_reid, mailroom_screamer).
actor(the_hudsucker_proxy, mike_starr, newsroom_reporter).
actor(the_hudsucker_proxy, david_hagar, newsroom_reporter).
actor(the_hudsucker_proxy, willie_reale, newsroom_reporter).
actor(the_hudsucker_proxy, harvey_meyer, newsroom_reporter).
actor(the_hudsucker_proxy, tom_toner, newsroom_reporter).
actor(the_hudsucker_proxy, david_fawcett, newsroom_reporter).
actor(the_hudsucker_proxy, jeff_still, newsreel_reporter).
actor(the_hudsucker_proxy, david_gould, newsreel_reporter).
actor(the_hudsucker_proxy, gil_pearson, newsreel_reporter).
actor(the_hudsucker_proxy, marc_garber, newsreel_reporter).
actor(the_hudsucker_proxy, david_massie, newsreel_reporter).
actor(the_hudsucker_proxy, mark_jeffrey_miller, newsreel_reporter).
actor(the_hudsucker_proxy, peter_siragusa, newsreel_reporter).
actor(the_hudsucker_proxy, nelson_george, newsreel_reporter).
actor(the_hudsucker_proxy, michael_houlihan, newsreel_reporter).
actor(the_hudsucker_proxy, ed_lillard, newsreel_reporter).
actor(the_hudsucker_proxy, wantland_sandel, new_year_s_mob).
actor(the_hudsucker_proxy, james_deuter, new_year_s_mob).
actor(the_hudsucker_proxy, roderick_peeples, new_year_s_mob).
actress(the_hudsucker_proxy, cynthia_baker, new_year_s_mob).
actor(the_hudsucker_proxy, jack_rooney, man_at_merchandise_mart).
actor(the_hudsucker_proxy, keith_schrader, businessman).

movie(inside_monkey_zetterland, 1992).
director(inside_monkey_zetterland, jefery_levy).
actor(inside_monkey_zetterland, steve_antin, monkey_zetterland).
actress(inside_monkey_zetterland, patricia_arquette, grace_zetterland).
actress(inside_monkey_zetterland, sandra_bernhard, imogene).
actress(inside_monkey_zetterland, sofia_coppola, cindy).
actor(inside_monkey_zetterland, tate_donovan, brent_zetterland).
actor(inside_monkey_zetterland, rupert_everett, sasha).
actress(inside_monkey_zetterland, katherine_helmond, honor_zetterland).
actor(inside_monkey_zetterland, bo_hopkins, mike_zetterland).
actress(inside_monkey_zetterland, ricki_lake, bella_the_stalker).
actress(inside_monkey_zetterland, debi_mazar, daphne).
actress(inside_monkey_zetterland, martha_plimpton, sofie).
actress(inside_monkey_zetterland, robin_antin, waitress).
actress(inside_monkey_zetterland, frances_bay, grandma).
actor(inside_monkey_zetterland, luca_bercovici, boot_guy).
actress(inside_monkey_zetterland, melissa_lechner, observation_psychiatrist).
actor(inside_monkey_zetterland, lance_loud, psychiatrist).
actor(inside_monkey_zetterland, chris_nash, police_officer).
actress(inside_monkey_zetterland, vivian_schilling, network_producer).
actress(inside_monkey_zetterland, blair_tefkin, brent_s_assistant).

movie(intolerable_cruelty, 2003).
director(intolerable_cruelty, ethan_coen).
director(intolerable_cruelty, joel_coen).
actor(intolerable_cruelty, george_clooney, miles_massey).
actress(intolerable_cruelty, catherine_zeta_jones, marylin_rexroth).
actor(intolerable_cruelty, geoffrey_rush, donovan_donaly).
actor(intolerable_cruelty, cedric_the_entertainer, gus_petch).
actor(intolerable_cruelty, edward_herrmann, rex_rexroth).
actor(intolerable_cruelty, paul_adelstein, wrigley).
actor(intolerable_cruelty, richard_jenkins, freddy_bender).
actor(intolerable_cruelty, billy_bob_thornton, howard_d_doyle).
actress(intolerable_cruelty, julia_duffy, sarah_sorkin).
actor(intolerable_cruelty, jonathan_hadary, heinz_the_baron_krauss_von_espy).
actor(intolerable_cruelty, tom_aldredge, herb_myerson).
actress(intolerable_cruelty, stacey_travis, bonnie_donaly).
actor(intolerable_cruelty, jack_kyle, ollie_olerud).
actor(intolerable_cruelty, irwin_keyes, wheezy_joe).
actress(intolerable_cruelty, judith_drake, mrs_gutman).
actor(intolerable_cruelty, royce_d_applegate, mr_gutman).
actor(intolerable_cruelty, george_ives, mr_gutman_s_lawyer).
actor(intolerable_cruelty, booth_colman, gutman_trial_judge).
actress(intolerable_cruelty, kristin_dattilo, rex_s_young_woman).
actress(intolerable_cruelty, wendle_josepher, miles_receptionist).
actress(intolerable_cruelty, mary_pat_gleason, nero_s_waitress).
actress(intolerable_cruelty, mia_cottet, ramona_barcelona).
actress(intolerable_cruelty, kiersten_warren, claire_o_mara).
actor(intolerable_cruelty, rosey_brown, gus_s_pal).
actor(intolerable_cruelty, ken_sagoes, gus_s_pal).
actor(intolerable_cruelty, dale_e_turner, gus_s_pal).
actor(intolerable_cruelty, douglas_fisher, maitre_d).
actor(intolerable_cruelty, nicholas_shaffer, waiter).
actress(intolerable_cruelty, isabell_o_connor, judge_marva_munson).
actress(intolerable_cruelty, mary_gillis, court_reporter).
actor(intolerable_cruelty, colin_linden, father_scott).
actress(intolerable_cruelty, julie_osburn, stewardess).
actor(intolerable_cruelty, gary_marshal, las_vegas_waiter).
actor(intolerable_cruelty, blake_clark, convention_secretary).
actor(intolerable_cruelty, allan_trautman, convention_lawyer).
actress(intolerable_cruelty, kate_luyben, santa_fe_tart).
actress(intolerable_cruelty, kitana_baker, santa_fe_tart).
actress(intolerable_cruelty, camille_anderson, santa_fe_tart).
actress(intolerable_cruelty, tamie_sheffield, santa_fe_tart).
actress(intolerable_cruelty, bridget_marquardt, santa_fe_tart).
actress(intolerable_cruelty, emma_harrison, santa_fe_tart).
actor(intolerable_cruelty, john_bliss, mr_mackinnon).
actor(intolerable_cruelty, patrick_thomas_o_brien, bailiff).
actor(intolerable_cruelty, sean_fanton, bailiff).
actress(intolerable_cruelty, justine_baker, wedding_guest).
actor(intolerable_cruelty, bruce_campbell, soap_opera_actor_on_tv).
actress(intolerable_cruelty, barbara_kerr_condon, herb_myerson_s_private_nurse).
actor(intolerable_cruelty, jason_de_hoyos, gardener).
actor(intolerable_cruelty, larry_vigus, lawyer).
actress(intolerable_cruelty, susan_yeagley, tart_1).

movie(the_ladykillers, 2004).
director(the_ladykillers, ethan_coen).
director(the_ladykillers, joel_coen).
actor(the_ladykillers, tom_hanks, professor_g_h_dorr).
actress(the_ladykillers, irma_p_hall, marva_munson).
actor(the_ladykillers, marlon_wayans, gawain_macsam).
actor(the_ladykillers, j_k_simmons, garth_pancake).
actor(the_ladykillers, tzi_ma, the_general).
actor(the_ladykillers, ryan_hurst, lump_hudson).
actress(the_ladykillers, diane_delano, mountain_girl).
actor(the_ladykillers, george_wallace, sheriff_wyner).
actor(the_ladykillers, john_mcconnell, deputy_sheriff).
actor(the_ladykillers, jason_weaver, weemack_funthes).
actor(the_ladykillers, stephen_root, fernand_gudge).
actress(the_ladykillers, lyne_odums, rosalie_funthes).
actor(the_ladykillers, walter_k_jordan, elron).
actor(the_ladykillers, george_anthony_bell, preacher).
actor(the_ladykillers, greg_grunberg, tv_commercial_director).
actress(the_ladykillers, hallie_singleton, craft_service).
actor(the_ladykillers, robert_baker, quarterback).
actor(the_ladykillers, blake_clark, football_coach).
actor(the_ladykillers, amad_jackson, doughnut_gangster).
actor(the_ladykillers, aldis_hodge, doughnut_gangster).
actress(the_ladykillers, freda_foh_shen, doughnut_woman).
actress(the_ladykillers, paula_martin, gawain_s_mama).
actor(the_ladykillers, jeremy_suarez, li_l_gawain).
actress(the_ladykillers, te_te_benn, gawain_s_sister).
actor(the_ladykillers, khalil_east, gawain_s_brother).
actress(the_ladykillers, jennifer_echols, waffle_hut_waitress).
actress(the_ladykillers, nita_norris, tea_lady).
actress(the_ladykillers, vivian_smallwood, tea_lady).
actress(the_ladykillers, maryn_tasco, tea_lady).
actress(the_ladykillers, muriel_whitaker, tea_lady).
actress(the_ladykillers, jessie_bailey, tea_lady).
actress(the_ladykillers, louisa_abernathy, church_voice).
actress(the_ladykillers, mildred_dumas, church_voice).
actor(the_ladykillers, al_fann, church_voice).
actress(the_ladykillers, mi_mi_green_fann, church_voice).
actor(the_ladykillers, maurice_watson, othar).
actor(the_ladykillers, bruce_campbell, humane_society_worker).
actor(the_ladykillers, michael_dotson, angry_football_fan).

movie(lick_the_star, 1998).
director(lick_the_star, sofia_coppola).
actress(lick_the_star, christina_turley, kate).
actress(lick_the_star, audrey_heaven, chloe).
actress(lick_the_star, julia_vanderham, rebecca).
actress(lick_the_star, lindsy_drummer, sara).
actor(lick_the_star, robert_schwartzman, greg).
actress(lick_the_star, rachael_vanni, wendy).
actor(lick_the_star, peter_bogdanovich, principal).
actress(lick_the_star, zoe_r_cassavetes, p_e_teacher).
actress(lick_the_star, anahid_nazarian, social_studies_teacher).
actress(lick_the_star, davia_nelson, english_teacher).
actress(lick_the_star, christianna_toler, nadine).
actress(lick_the_star, hilary_fleming, taco_girl).
actress(lick_the_star, eleanor_cummings, sixth_grader_p_e_victim).
actor(lick_the_star, anthony_desimone, snack_counter_victim).
actor(lick_the_star, aron_acord, sexy_boy).

movie(lost_in_translation, 2003).
director(lost_in_translation, sofia_coppola).
actress(lost_in_translation, scarlett_johansson, charlotte).
actor(lost_in_translation, bill_murray, bob_harris).
actress(lost_in_translation, akiko_takeshita, ms_kawasaki).
actor(lost_in_translation, kazuyoshi_minamimagoe, press_agent).
actor(lost_in_translation, kazuko_shibata, press_agent).
actor(lost_in_translation, take, press_agent).
actor(lost_in_translation, ryuichiro_baba, concierge).
actor(lost_in_translation, akira_yamaguchi, bellboy).
actress(lost_in_translation, catherine_lambert, jazz_singer).
actor(lost_in_translation, fran_ois_du_bois, sausalito_piano).
actor(lost_in_translation, tim_leffman, sausalito_guitar).
actor(lost_in_translation, gregory_pekar, american_businessman_1).
actor(lost_in_translation, richard_allen, american_businessman_2).
actor(lost_in_translation, giovanni_ribisi, john).
actor(lost_in_translation, diamond_yukai, commercial_director).
actor(lost_in_translation, jun_maki, suntory_client).
actress(lost_in_translation, nao_asuka, premium_fantasy_woman).
actor(lost_in_translation, tetsuro_naka, stills_photographer).
actor(lost_in_translation, kanako_nakazato, make_up_person).
actor(lost_in_translation, fumihiro_hayashi, charlie).
actress(lost_in_translation, hiroko_kawasaki, hiroko).
actress(lost_in_translation, daikon, bambie).
actress(lost_in_translation, anna_faris, kelly).
actor(lost_in_translation, asuka_shimuzu, kelly_s_translator).
actor(lost_in_translation, ikuko_takahashi, ikebana_instructor).
actor(lost_in_translation, koichi_tanaka, bartender_ny_bar).
actor(lost_in_translation, hugo_codaro, aerobics_instructor).
actress(lost_in_translation, akiko_monou, p_chan).
actor(lost_in_translation, akimitsu_naruyama, french_japanese_nightclub_patron).
actor(lost_in_translation, hiroshi_kawashima, bartender_nightclub).
actress(lost_in_translation, toshikawa_hiromi, hiromix).
actor(lost_in_translation, nobuhiko_kitamura, nobu).
actor(lost_in_translation, nao_kitman, nao).
actor(lost_in_translation, akira, hans).
actor(lost_in_translation, kunichi_nomura, kun).
actor(lost_in_translation, yasuhiko_hattori, charlie_s_friend).
actor(lost_in_translation, shigekazu_aida, mr_valentine).
actor(lost_in_translation, kazuo_yamada, hospital_receptionist).
actor(lost_in_translation, akira_motomura, old_man).
actor(lost_in_translation, osamu_shigematu, doctor).
actor(lost_in_translation, takashi_fujii, tv_host).
actor(lost_in_translation, kei_takyo, tv_translator).
actor(lost_in_translation, ryo_kondo, politician).
actor(lost_in_translation, yumi_ikeda, politician_s_aide).
actor(lost_in_translation, yumika_saki, politician_s_aide).
actor(lost_in_translation, yuji_okabe, politician_s_aide).
actor(lost_in_translation, diedrich_bollman, german_hotel_guest).
actor(lost_in_translation, georg_o_p_eschert, german_hotel_guest).
actor(lost_in_translation, mark_willms, carl_west).
actress(lost_in_translation, lisle_wilkerson, sexy_businesswoman).
actress(lost_in_translation, nancy_steiner, lydia_harris).

movie(the_man_who_wasn_t_there, 2001).
director(the_man_who_wasn_t_there, ethan_coen).
director(the_man_who_wasn_t_there, joel_coen).
actor(the_man_who_wasn_t_there, billy_bob_thornton, ed_crane).
actress(the_man_who_wasn_t_there, frances_mcdormand, doris_crane).
actor(the_man_who_wasn_t_there, michael_badalucco, frank).
actor(the_man_who_wasn_t_there, james_gandolfini, dave_big_dave_brewster).
actress(the_man_who_wasn_t_there, katherine_borowitz, ann_nirdlinger).
actor(the_man_who_wasn_t_there, jon_polito, creighton_tolliver).
actress(the_man_who_wasn_t_there, scarlett_johansson, rachel_birdy_abundas).
actor(the_man_who_wasn_t_there, richard_jenkins, walter_abundas).
actor(the_man_who_wasn_t_there, tony_shalhoub, freddy_riedenschneider).
actor(the_man_who_wasn_t_there, christopher_kriesa, officer_persky).
actor(the_man_who_wasn_t_there, brian_haley, officer_pete_krebs).
actor(the_man_who_wasn_t_there, jack_mcgee, burns).
actor(the_man_who_wasn_t_there, gregg_binkley, the_new_man).
actor(the_man_who_wasn_t_there, alan_fudge, diedrickson).
actress(the_man_who_wasn_t_there, lilyan_chauvin, medium).
actor(the_man_who_wasn_t_there, adam_alexi_malle, jacques_carcanogues).
actor(the_man_who_wasn_t_there, ted_rooney, bingo_caller).
actor(the_man_who_wasn_t_there, abraham_benrubi, young_man).
actor(the_man_who_wasn_t_there, christian_ferratti, child).
actress(the_man_who_wasn_t_there, rhoda_gemignani, costanza).
actor(the_man_who_wasn_t_there, e_j_callahan, customer).
actress(the_man_who_wasn_t_there, brooke_smith, sobbing_prisoner).
actor(the_man_who_wasn_t_there, ron_ross, banker).
actress(the_man_who_wasn_t_there, hallie_singleton, waitress).
actor(the_man_who_wasn_t_there, jon_donnelly, gatto_eater).
actor(the_man_who_wasn_t_there, dan_martin, bailiff).
actor(the_man_who_wasn_t_there, nicholas_lanier, tony).
actor(the_man_who_wasn_t_there, tom_dahlgren, judge_1).
actor(the_man_who_wasn_t_there, booth_colman, judge_2).
actor(the_man_who_wasn_t_there, stanley_desantis, new_man_s_customer).
actor(the_man_who_wasn_t_there, peter_siragusa, bartender).
actor(the_man_who_wasn_t_there, christopher_mcdonald, macadam_salesman).
actor(the_man_who_wasn_t_there, rick_scarry, district_attorney).
actor(the_man_who_wasn_t_there, george_ives, lloyd_garroway).
actor(the_man_who_wasn_t_there, devon_cole_borisoff, swimming_boy).
actress(the_man_who_wasn_t_there, mary_bogue, prisoner_visitor).
actor(the_man_who_wasn_t_there, don_donati, pie_contest_timer).
actor(the_man_who_wasn_t_there, arthur_reeves, flophouse_clerk).
actress(the_man_who_wasn_t_there, michelle_weber, dancer).
actress(the_man_who_wasn_t_there, randi_pareira, dancer).
actor(the_man_who_wasn_t_there, robert_loftin, dancer).
actor(the_man_who_wasn_t_there, kenneth_hughes, dancer).
actor(the_man_who_wasn_t_there, gordon_hart, dancer).
actress(the_man_who_wasn_t_there, brenda_mae_hamilton, dancer).
actor(the_man_who_wasn_t_there, lloyd_gordon, dancer).
actor(the_man_who_wasn_t_there, leonard_crofoot, dancer).
actress(the_man_who_wasn_t_there, rita_bland, dancer).
actress(the_man_who_wasn_t_there, audrey_k_baranishyn, dancer).
actress(the_man_who_wasn_t_there, qyn_hughes, dancer).
actress(the_man_who_wasn_t_there, rachel_mcdonald, dancer).
actor(the_man_who_wasn_t_there, craig_berenson, jail_guy).
actress(the_man_who_wasn_t_there, joan_m_blair, prison_matron).
actor(the_man_who_wasn_t_there, geoffrey_gould, alpine_rope_toss_man).
actor(the_man_who_wasn_t_there, phil_hawn, man_in_courtroom).
actress(the_man_who_wasn_t_there, cherilyn_hayres, swing_dancer).
actor(the_man_who_wasn_t_there, john_michael_higgins, emergency_room_physician).
actress(the_man_who_wasn_t_there, monika_malmrose, crying_girl).
actor(the_man_who_wasn_t_there, peter_schrum, truck_driver).
actor(the_man_who_wasn_t_there, max_thayer, witness).

movie(marie_antoinette, 2006).
director(marie_antoinette, sofia_coppola).
actress(marie_antoinette, kirsten_dunst, marie_antoinette).
actor(marie_antoinette, jason_schwartzman, louis_xvi).
actor(marie_antoinette, rip_torn, king_louis_xv).
actress(marie_antoinette, judy_davis, comtesse_de_noailles).
actress(marie_antoinette, asia_argento, madame_du_barry).
actress(marie_antoinette, marianne_faithfull, maria_theresia).
actress(marie_antoinette, aurore_cl_ment, la_duchesse_de_chartres).
actor(marie_antoinette, guillaume_gallienne, comte_vergennes).
actress(marie_antoinette, clementine_poidatz, comtesse_de_provence).
actress(marie_antoinette, molly_shannon, anne_victoire).
actor(marie_antoinette, steve_coogan, count_mercy_d_argenteau).
actor(marie_antoinette, jamie_dornan, axel_von_fersen).
actress(marie_antoinette, shirley_henderson, aunt_sophie).
actor(marie_antoinette, jean_christophe_bouvet, duc_de_choiseul).
actor(marie_antoinette, filippo_bozotti, dimitri).
actress(marie_antoinette, sarah_adler, '').
actor(marie_antoinette, mathieu_amalric, man_at_the_masked_ball).
actress(marie_antoinette, rachel_berger, lady_m_b).
actor(marie_antoinette, xavier_bonastre, court_member).
actress(marie_antoinette, io_bottoms, lady_in_waiting_1).
actress(marie_antoinette, sol_ne_bouton, '').
actress(marie_antoinette, rose_byrne, yolande_martine_gabrielle_de_polastron_duchesse_de_polignac).
actor(marie_antoinette, alain_doutey, '').
actor(marie_antoinette, gilles_dufour, '').
actress(marie_antoinette, sabine_glaser, court_member).
actress(marie_antoinette, h_loise_godet, court_member).
actress(marie_antoinette, manon_grosset, une_page).
actor(marie_antoinette, philippe_h_li_s, king_s_aide_de_camp_2).
actor(marie_antoinette, arnaud_klein, garde_royal_royal_guard).
actress(marie_antoinette, aleksia_landeau, countesse_de_castelabjac).
actor(marie_antoinette, benjamin_lemaire, un_page).
actor(marie_antoinette, victor_loukianenko, le_valet_de_marie_antoinette).
actor(marie_antoinette, rapha_l_neal, garden_page).
actress(marie_antoinette, mary_nighy, '').
actor(marie_antoinette, al_weaver, '').

movie(miller_s_crossing, 1990).
director(miller_s_crossing, ethan_coen).
director(miller_s_crossing, joel_coen).
actor(miller_s_crossing, gabriel_byrne, tom_reagan).
actress(miller_s_crossing, marcia_gay_harden, verna).
actor(miller_s_crossing, john_turturro, bernie_bernbaum).
actor(miller_s_crossing, jon_polito, johnny_caspar).
actor(miller_s_crossing, j_e_freeman, eddie_dane).
actor(miller_s_crossing, albert_finney, leo).
actor(miller_s_crossing, mike_starr, frankie).
actor(miller_s_crossing, al_mancini, tic_tac).
actor(miller_s_crossing, richard_woods, mayor_dale_levander).
actor(miller_s_crossing, thomas_toner, o_doole).
actor(miller_s_crossing, steve_buscemi, mink).
actor(miller_s_crossing, mario_todisco, clarence_drop_johnson).
actor(miller_s_crossing, olek_krupa, tad).
actor(miller_s_crossing, michael_jeter, adolph).
actor(miller_s_crossing, lanny_flaherty, terry).
actress(miller_s_crossing, jeanette_kontomitras, mrs_caspar).
actor(miller_s_crossing, louis_charles_mounicou_iii, johnny_caspar_jr).
actor(miller_s_crossing, john_mcconnell, cop__brian).
actor(miller_s_crossing, danny_aiello_iii, cop__delahanty).
actress(miller_s_crossing, helen_jolly, screaming_lady).
actress(miller_s_crossing, hilda_mclean, landlady).
actor(miller_s_crossing, monte_starr, gunman_in_leo_s_house).
actor(miller_s_crossing, don_picard, gunman_in_leo_s_house).
actor(miller_s_crossing, salvatore_h_tornabene, rug_daniels).
actor(miller_s_crossing, kevin_dearie, street_urchin).
actor(miller_s_crossing, michael_badalucco, caspar_s_driver).
actor(miller_s_crossing, charles_ferrara, caspar_s_butler).
actor(miller_s_crossing, esteban_fern_ndez, caspar_s_cousin).
actor(miller_s_crossing, george_fernandez, caspar_s_cousin).
actor(miller_s_crossing, charles_gunning, hitman_at_verna_s).
actor(miller_s_crossing, dave_drinkx, hitman_2).
actor(miller_s_crossing, david_darlow, lazarre_s_messenger).
actor(miller_s_crossing, robert_labrosse, lazarre_s_tough).
actor(miller_s_crossing, carl_rooney, lazarre_s_tough).
actor(miller_s_crossing, jack_harris, man_with_pipe_bomb).
actor(miller_s_crossing, jery_hewitt, son_of_erin).
actor(miller_s_crossing, sam_raimi, snickering_gunman).
actor(miller_s_crossing, john_schnauder_jr, cop_with_bullhorn).
actor(miller_s_crossing, zolly_levin, rabbi).
actor(miller_s_crossing, joey_ancona, boxer).
actor(miller_s_crossing, bill_raye, boxer).
actor(miller_s_crossing, william_preston_robertson, voice).
actress(miller_s_crossing, frances_mcdormand, mayor_s_secretary).

movie(mission_impossible, 1996).
director(mission_impossible, brian_de_palma).
actor(mission_impossible, tom_cruise, ethan_hunt).
actor(mission_impossible, jon_voight, jim_phelps).
actress(mission_impossible, emmanuelle_b_art, claire_phelps).
actor(mission_impossible, henry_czerny, eugene_kittridge).
actor(mission_impossible, jean_reno, franz_krieger).
actor(mission_impossible, ving_rhames, luther_stickell).
actress(mission_impossible, kristin_scott_thomas, sarah_davies).
actress(mission_impossible, vanessa_redgrave, max).
actor(mission_impossible, dale_dye, frank_barnes).
actor(mission_impossible, marcel_iures, golitsyn).
actor(mission_impossible, ion_caramitru, zozimov).
actress(mission_impossible, ingeborga_dapkunaite, hannah_williams).
actress(mission_impossible, valentina_yakunina, drunken_female_imf_agent).
actor(mission_impossible, marek_vasut, drunken_male_imf_agent).
actor(mission_impossible, nathan_osgood, kittridge_technician).
actor(mission_impossible, john_mclaughlin, tv_interviewer).
actor(mission_impossible, rolf_saxon, cia_analyst_william_donloe).
actor(mission_impossible, karel_dobry, matthias).
actor(mission_impossible, andreas_wisniewski, max_s_companion).
actor(mission_impossible, david_shaeffer, diplomat_rand_housman).
actor(mission_impossible, rudolf_pechan, mayor_brandl).
actor(mission_impossible, gaston_subert, jaroslav_reid).
actor(mission_impossible, ricco_ross, denied_area_security_guard).
actor(mission_impossible, mark_houghton, denied_area_security_guard).
actor(mission_impossible, bob_friend, sky_news_man).
actress(mission_impossible, annabel_mullion, flight_attendant).
actor(mission_impossible, garrick_hagon, cnn_reporter).
actor(mission_impossible, olegar_fedoro, kiev_room_agent).
actor(mission_impossible, sam_douglas, kiev_room_agent).
actor(mission_impossible, andrzej_borkowski, kiev_room_agent).
actress(mission_impossible, maya_dokic, kiev_room_agent).
actress(mission_impossible, carmela_marner, kiev_room_agent).
actress(mission_impossible, mimi_potworowska, kiev_room_agent).
actress(mission_impossible, jirina_trebick, cleaning_woman).
actor(mission_impossible, david_schneider, train_engineer).
actress(mission_impossible, helen_lindsay, female_executive_in_train).
actress(mission_impossible, pat_starr, cia_agent).
actor(mission_impossible, richard_d_sharp, cia_lobby_guard).
actor(mission_impossible, randall_paul, cia_escort_guard).
actress(mission_impossible, sue_doucette, cia_agent).
actor(mission_impossible, graydon_gould, public_official).
actor(mission_impossible, tony_vogel, m_i_5).
actor(mission_impossible, michael_rogers, large_man).
actress(mission_impossible, laura_brook, margaret_hunt).
actor(mission_impossible, morgan_deare, donald_hunt).
actor(mission_impossible, david_phelan, steward_on_train).
actress(mission_impossible, melissa_knatchbull, air_stewardess).
actor(mission_impossible, keith_campbell, fireman).
actor(mission_impossible, michael_cella, student).
actor(mission_impossible, emilio_estevez, jack_harmon).
actor(mission_impossible, john_knoll, passenger_on_train_in_tunnel).

movie(no_country_for_old_men, 2007).
director(no_country_for_old_men, joel_coen).

movie(o_brother_where_art_thou, 2000).
director(o_brother_where_art_thou, ethan_coen).
director(o_brother_where_art_thou, joel_coen).
actor(o_brother_where_art_thou, george_clooney, ulysses_everett_mcgill).
actor(o_brother_where_art_thou, john_turturro, pete).
actor(o_brother_where_art_thou, tim_blake_nelson, delmar_o_donnell).
actor(o_brother_where_art_thou, john_goodman, big_dan_teague).
actress(o_brother_where_art_thou, holly_hunter, penny).
actor(o_brother_where_art_thou, chris_thomas_king, tommy_johnson).
actor(o_brother_where_art_thou, charles_durning, pappy_o_daniel).
actor(o_brother_where_art_thou, del_pentecost, junior_o_daniel).
actor(o_brother_where_art_thou, michael_badalucco, george_nelson).
actor(o_brother_where_art_thou, j_r_horne, pappy_s_staff).
actor(o_brother_where_art_thou, brian_reddy, pappy_s_staff).
actor(o_brother_where_art_thou, wayne_duvall, homer_stokes).
actor(o_brother_where_art_thou, ed_gale, the_little_man).
actor(o_brother_where_art_thou, ray_mckinnon, vernon_t_waldrip).
actor(o_brother_where_art_thou, daniel_von_bargen, sheriff_cooley_the_devil).
actor(o_brother_where_art_thou, royce_d_applegate, man_with_bullhorn).
actor(o_brother_where_art_thou, frank_collison, wash_hogwallop).
actor(o_brother_where_art_thou, quinn_gasaway, boy_hogwallop).
actor(o_brother_where_art_thou, lee_weaver, blind_seer).
actor(o_brother_where_art_thou, millford_fortenberry, pomade_vendor).
actor(o_brother_where_art_thou, stephen_root, radio_station_man).
actor(o_brother_where_art_thou, john_locke, mr_french).
actress(o_brother_where_art_thou, gillian_welch, soggy_bottom_customer).
actor(o_brother_where_art_thou, a_ray_ratliff, record_store_clerk).
actress(o_brother_where_art_thou, mia_tate, siren).
actress(o_brother_where_art_thou, musetta_vander, siren).
actress(o_brother_where_art_thou, christy_taylor, siren).
actress(o_brother_where_art_thou, april_hardcastle, waitress).
actor(o_brother_where_art_thou, michael_w_finnell, interrogator).
actress(o_brother_where_art_thou, georgia_rae_rainer, wharvey_gal).
actress(o_brother_where_art_thou, marianna_breland, wharvey_gal).
actress(o_brother_where_art_thou, lindsey_miller, wharvey_gal).
actress(o_brother_where_art_thou, natalie_shedd, wharvey_gal).
actor(o_brother_where_art_thou, john_mcconnell, woolworths_manager).
actor(o_brother_where_art_thou, issac_freeman, gravedigger).
actor(o_brother_where_art_thou, wilson_waters_jr, gravedigger).
actor(o_brother_where_art_thou, robert_hamlett, gravedigger).
actor(o_brother_where_art_thou, willard_cox, cox_family).
actress(o_brother_where_art_thou, evelyn_cox, cox_family).
actress(o_brother_where_art_thou, suzanne_cox, cox_family).
actor(o_brother_where_art_thou, sidney_cox, cox_family).
actor(o_brother_where_art_thou, buck_white, the_whites).
actress(o_brother_where_art_thou, sharon_white, the_whites).
actress(o_brother_where_art_thou, cheryl_white, the_whites).
actor(o_brother_where_art_thou, ed_snodderly, village_idiot).
actor(o_brother_where_art_thou, david_holt, village_idiot).
actor(o_brother_where_art_thou, jerry_douglas, dobro_player).
actor(o_brother_where_art_thou, christopher_francis, kkk_member).
actor(o_brother_where_art_thou, geoffrey_gould, head_of_mob).
actor(o_brother_where_art_thou, nathaniel_lee_jr, ice_boy_on_the_right_straw_hat).

movie(the_outsiders, 1983).
director(the_outsiders, francis_ford_coppola).
actor(the_outsiders, matt_dillon, dallas_dally_winston).
actor(the_outsiders, ralph_macchio, johnny_cade).
actor(the_outsiders, c_thomas_howell, ponyboy_curtis).
actor(the_outsiders, patrick_swayze, darrel_darry_curtis).
actor(the_outsiders, rob_lowe, sodapop_curtis).
actor(the_outsiders, emilio_estevez, keith_two_bit_mathews).
actor(the_outsiders, tom_cruise, steve_randle).
actor(the_outsiders, glenn_withrow, tim_shepard).
actress(the_outsiders, diane_lane, sherri_cherry_valance).
actor(the_outsiders, leif_garrett, bob_sheldon).
actor(the_outsiders, darren_dalton, randy_anderson).
actress(the_outsiders, michelle_meyrink, marcia).
actor(the_outsiders, gailard_sartain, jerry_wood).
actor(the_outsiders, tom_waits, buck_merrill).
actor(the_outsiders, william_smith, store_clerk).
actor(the_outsiders, tom_hillmann, greaser_in_concession_stand).
actor(the_outsiders, hugh_walkinshaw, soc_in_concession_stand).
actress(the_outsiders, sofia_coppola, little_girl).
actress(the_outsiders, teresa_wilkerson_hunt, woman_at_fire).
actress(the_outsiders, linda_nystedt, nurse).
actress(the_outsiders, s_e_hinton, nurse).
actor(the_outsiders, brent_beesley, suburb_guy).
actor(the_outsiders, john_meier, paul).
actor(the_outsiders, ed_jackson, motorcycle_cop).
actor(the_outsiders, daniel_r_suhart, orderly).
actress(the_outsiders, heather_langenkamp, '').

movie(paris_je_t_aime, 2006).
director(paris_je_t_aime, olivier_assayas).
director(paris_je_t_aime, fr_d_ric_auburtin).
director(paris_je_t_aime, christoffer_boe).
director(paris_je_t_aime, sylvain_chomet).
director(paris_je_t_aime, ethan_coen).
director(paris_je_t_aime, joel_coen).
director(paris_je_t_aime, isabel_coixet).
director(paris_je_t_aime, alfonso_cuar_n).
director(paris_je_t_aime, g_rard_depardieu).
director(paris_je_t_aime, jean_luc_godard).
director(paris_je_t_aime, richard_lagravenese).
director(paris_je_t_aime, anne_marie_mi_ville).
director(paris_je_t_aime, vincenzo_natali).
director(paris_je_t_aime, alexander_payne).
director(paris_je_t_aime, walter_salles).
director(paris_je_t_aime, oliver_schmitz).
director(paris_je_t_aime, ettore_scola).
director(paris_je_t_aime, nobuhiro_suwa).
director(paris_je_t_aime, daniela_thomas).
director(paris_je_t_aime, tom_tykwer).
director(paris_je_t_aime, gus_van_sant).
actress(paris_je_t_aime, emilie_ohana, the_young_parisian_recurrent_character).
actress(paris_je_t_aime, julie_bataille, julie_segment_1st_arrondissement).
actor(paris_je_t_aime, steve_buscemi, the_tourist_segment_1st_arrondissement).
actor(paris_je_t_aime, axel_kiener, axel_segment_1st_arrondissement).
actress(paris_je_t_aime, juliette_binoche, the_mother_segment_2nd_arrondissement).
actor(paris_je_t_aime, willem_dafoe, the_cow_boy_segment_2nd_arrondissement).
actress(paris_je_t_aime, marianne_faithfull, segment_4th_arrondissement).
actor(paris_je_t_aime, elias_mcconnell, eli_segment_4th_arrondissement).
actor(paris_je_t_aime, gaspard_ulliel, gaspar_segment_4th_arrondissement).
actor(paris_je_t_aime, ben_gazzara, ben_segment_6th_arrondissement).
actress(paris_je_t_aime, gena_rowlands, gena_segment_6th_arrondissement).
actress(paris_je_t_aime, yolande_moreau, female_mime_segment_7th_arrondissement).
actor(paris_je_t_aime, paul_putner, male_mime_segment_7th_arrondissement).
actress(paris_je_t_aime, olga_kurylenko, the_femme_fatale_segment_8th_arrondissement).
actress(paris_je_t_aime, fanny_ardant, fanny_forestier_segment_9th_arrondissement).
actor(paris_je_t_aime, bob_hoskins, bob_leander_segment_9th_arrondissement).
actor(paris_je_t_aime, melchior_beslon, thomas_segment_10th_arrondissement).
actress(paris_je_t_aime, natalie_portman, francine_segment_10th_arrondissement).
actor(paris_je_t_aime, javier_c_mara, the_doctor_segment_12th_arrondissement).
actress(paris_je_t_aime, isabella_rossellini, the_wife_segment_12th_arrondissement).
actress(paris_je_t_aime, leonor_watling, segment_12th_arrondissement).
actress(paris_je_t_aime, camille_japy, anna_segment_15th_arrondissement).
actor(paris_je_t_aime, nick_nolte, vincent_segment_17th_arrondissement).
actress(paris_je_t_aime, ludivine_sagnier, claire_segment_17th_arrondissement).
actor(paris_je_t_aime, seydou_boro, hassan_segment_19th_arrondissement).
actress(paris_je_t_aime, a_ssa_ma_ga, sophie_segment_19th_arrondissement).

movie(peggy_sue_got_married, 1986).
director(peggy_sue_got_married, francis_ford_coppola).
actress(peggy_sue_got_married, kathleen_turner, peggy_sue_kelcher_peggy_sue_bodell).
actor(peggy_sue_got_married, nicolas_cage, charlie_bodell).
actor(peggy_sue_got_married, barry_miller, richard_norvik).
actress(peggy_sue_got_married, catherine_hicks, carol_heath).
actress(peggy_sue_got_married, joan_allen, maddy_nagle).
actor(peggy_sue_got_married, kevin_j_o_connor, michael_fitzsimmons).
actor(peggy_sue_got_married, jim_carrey, walter_getz).
actress(peggy_sue_got_married, lisa_jane_persky, delores_dodge).
actress(peggy_sue_got_married, lucinda_jenney, rosalie_testa).
actor(peggy_sue_got_married, wil_shriner, arthur_nagle).
actress(peggy_sue_got_married, barbara_harris, evelyn_kelcher).
actor(peggy_sue_got_married, don_murray, jack_kelcher).
actress(peggy_sue_got_married, sofia_coppola, nancy_kelcher).
actress(peggy_sue_got_married, maureen_o_sullivan, elizabeth_alvorg).
actor(peggy_sue_got_married, leon_ames, barney_alvorg).
actor(peggy_sue_got_married, randy_bourne, scott_bodell).
actress(peggy_sue_got_married, helen_hunt, beth_bodell).
actor(peggy_sue_got_married, don_stark, doug_snell).
actor(peggy_sue_got_married, marshall_crenshaw, reunion_band).
actor(peggy_sue_got_married, chris_donato, reunion_band).
actor(peggy_sue_got_married, robert_crenshaw, reunion_band).
actor(peggy_sue_got_married, tom_teeley, reunion_band).
actor(peggy_sue_got_married, graham_maby, reunion_band).
actor(peggy_sue_got_married, ken_grantham, mr_snelgrove).
actress(peggy_sue_got_married, ginger_taylor, janet).
actress(peggy_sue_got_married, sigrid_wurschmidt, sharon).
actor(peggy_sue_got_married, glenn_withrow, terry).
actor(peggy_sue_got_married, harry_basil, leon).
actor(peggy_sue_got_married, john_carradine, leo).
actress(peggy_sue_got_married, sachi_parker, lisa).
actress(peggy_sue_got_married, vivien_straus, sandy).
actor(peggy_sue_got_married, morgan_upton, mr_gilford).
actor(peggy_sue_got_married, dr_lewis_leibovich, dr_daly).
actor(peggy_sue_got_married, bill_bonham, drunk).
actor(peggy_sue_got_married, joe_lerer, drunk_creep).
actress(peggy_sue_got_married, barbara_oliver, nurse).
actor(peggy_sue_got_married, martin_scott, the_four_mations).
actor(peggy_sue_got_married, marcus_scott, the_four_mations).
actor(peggy_sue_got_married, carl_lockett, the_four_mations).
actor(peggy_sue_got_married, tony_saunders, the_four_mations).
actor(peggy_sue_got_married, vincent_lars, the_four_mations).
actor(peggy_sue_got_married, larry_e_vann, the_four_mations).
actor(peggy_sue_got_married, lawrence_menkin, elderly_gentleman).
actor(peggy_sue_got_married, daniel_r_suhart, chinese_waiter).
actor(peggy_sue_got_married, leslie_hilsinger, majorette).
actor(peggy_sue_got_married, al_nalbandian, lodge_member).
actor(peggy_sue_got_married, dan_leegant, lodge_member).
actor(peggy_sue_got_married, ron_cook, lodge_member).
actress(peggy_sue_got_married, mary_leichtling, reunion_receptionist).
actress(peggy_sue_got_married, cynthia_brian, reunion_woman_2).
actor(peggy_sue_got_married, michael_x_martin, '').
actress(peggy_sue_got_married, mary_mitchel, '').

movie(raising_arizona, 1987).
director(raising_arizona, ethan_coen).
director(raising_arizona, joel_coen).
actor(raising_arizona, nicolas_cage, h_i_mcdonnough).
actress(raising_arizona, holly_hunter, edwina_ed_mcdonnough).
actor(raising_arizona, trey_wilson, nathan_arizona_huffhines_sr).
actor(raising_arizona, john_goodman, gale_snoats).
actor(raising_arizona, william_forsythe, evelle_snoats).
actor(raising_arizona, sam_mcmurray, glen).
actress(raising_arizona, frances_mcdormand, dot).
actor(raising_arizona, randall_tex_cobb, leonard_smalls).
actor(raising_arizona, t_j_kuhn, nathan_arizona_jr).
actress(raising_arizona, lynne_dumin_kitei, florence_arizona).
actor(raising_arizona, peter_benedek, prison_counselor).
actor(raising_arizona, charles_lew_smith, nice_old_grocery_man).
actor(raising_arizona, warren_keith, younger_fbi_agent).
actor(raising_arizona, henry_kendrick, older_fbi_agent).
actor(raising_arizona, sidney_dawson, moses_ear_bending_cellmate).
actor(raising_arizona, richard_blake, parole_board_chairman).
actor(raising_arizona, troy_nabors, parole_board_member).
actress(raising_arizona, mary_seibel, parole_board_member).
actor(raising_arizona, john_o_donnal, hayseed_in_the_pickup).
actor(raising_arizona, keith_jandacek, whitey).
actor(raising_arizona, warren_forsythe, minister).
actor(raising_arizona, ruben_young, trapped_convict).
actor(raising_arizona, dennis_sullivan, policeman_in_arizona_house).
actor(raising_arizona, richard_alexander, policeman_in_arizona_house).
actor(raising_arizona, rusty_lee, feisty_hayseed).
actor(raising_arizona, james_yeater, fingerprint_technician).
actor(raising_arizona, bill_andres, reporter).
actor(raising_arizona, carver_barns, reporter).
actress(raising_arizona, margaret_h_mccormack, unpainted_arizona_secretary).
actor(raising_arizona, bill_rocz, newscaster).
actress(raising_arizona, mary_f_glenn, payroll_cashier).
actor(raising_arizona, jeremy_babendure, scamp_with_squirt_gun).
actor(raising_arizona, bill_dobbins, adoption_agent).
actor(raising_arizona, ralph_norton, gynecologist).
actor(raising_arizona, henry_tank, mopping_convict).
actor(raising_arizona, frank_outlaw, supermarket_manager).
actor(raising_arizona, todd_michael_rodgers, varsity_nathan_jr).
actor(raising_arizona, m_emmet_walsh, machine_shop_ear_bender).
actor(raising_arizona, robert_gray, glen_and_dot_s_kid).
actress(raising_arizona, katie_thrasher, glen_and_dot_s_kid).
actor(raising_arizona, derek_russell, glen_and_dot_s_kid).
actress(raising_arizona, nicole_russell, glen_and_dot_s_kid).
actor(raising_arizona, zachary_sanders, glen_and_dot_s_kid).
actress(raising_arizona, noell_sanders, glen_and_dot_s_kid).
actor(raising_arizona, cody_ranger, arizona_quint).
actor(raising_arizona, jeremy_arendt, arizona_quint).
actress(raising_arizona, ashley_hammon, arizona_quint).
actress(raising_arizona, crystal_hiller, arizona_quint).
actress(raising_arizona, olivia_hughes, arizona_quint).
actress(raising_arizona, emily_malin, arizona_quint).
actress(raising_arizona, melanie_malin, arizona_quint).
actor(raising_arizona, craig_mclaughlin, arizona_quint).
actor(raising_arizona, adam_savageau, arizona_quint).
actor(raising_arizona, benjamin_savageau, arizona_quint).
actor(raising_arizona, david_schneider, arizona_quint).
actor(raising_arizona, michael_stewart, arizona_quint).
actor(raising_arizona, william_preston_robertson, amazing_voice).
actor(raising_arizona, ron_francis_cobert, reporter_1).

movie(rumble_fish, 1983).
director(rumble_fish, francis_ford_coppola).
actor(rumble_fish, matt_dillon, rusty_james).
actor(rumble_fish, mickey_rourke, the_motorcycle_boy).
actress(rumble_fish, diane_lane, patty).
actor(rumble_fish, dennis_hopper, father).
actress(rumble_fish, diana_scarwid, cassandra).
actor(rumble_fish, vincent_spano, steve).
actor(rumble_fish, nicolas_cage, smokey).
actor(rumble_fish, chris_penn, b_j_jackson).
actor(rumble_fish, laurence_fishburne, midget).
actor(rumble_fish, william_smith, patterson_the_cop).
actor(rumble_fish, michael_higgins, mr_harrigan).
actor(rumble_fish, glenn_withrow, biff_wilcox).
actor(rumble_fish, tom_waits, benny).
actor(rumble_fish, herb_rice, black_pool_player).
actress(rumble_fish, maybelle_wallace, late_pass_clerk).
actress(rumble_fish, nona_manning, patty_s_mom).
actress(rumble_fish, sofia_coppola, donna_patty_s_sister).
actor(rumble_fish, gian_carlo_coppola, cousin_james).
actress(rumble_fish, s_e_hinton, hooker_on_strip).
actor(rumble_fish, emmett_brown, mr_dobson).
actor(rumble_fish, tracey_walter, alley_mugger_1).
actor(rumble_fish, lance_guecia, alley_mugger_2).
actor(rumble_fish, bob_maras, policeman).
actor(rumble_fish, j_t_turner, math_teacher).
actress(rumble_fish, keeva_clayton, lake_girl_1).
actress(rumble_fish, kirsten_hayden, lake_girl_2).
actress(rumble_fish, karen_parker, lake_girl_3).
actress(rumble_fish, sussannah_darcy, lake_girl_4).
actress(rumble_fish, kristi_somers, lake_girl_5).
actress(rumble_fish, heather_langenkamp, '').

movie(spies_like_us, 1985).
director(spies_like_us, john_landis).
actor(spies_like_us, chevy_chase, emmett_fitz_hume).
actor(spies_like_us, dan_aykroyd, austin_millbarge).
actor(spies_like_us, steve_forrest, general_sline).
actress(spies_like_us, donna_dixon, karen_boyer).
actor(spies_like_us, bruce_davison, ruby).
actor(spies_like_us, bernie_casey, colonel_rhumbus).
actor(spies_like_us, william_prince, keyes).
actor(spies_like_us, tom_hatten, general_miegs).
actor(spies_like_us, frank_oz, test_monitor).
actor(spies_like_us, charles_mckeown, jerry_hadley).
actor(spies_like_us, james_daughton, bob_hodges).
actor(spies_like_us, jim_staahl, bud_schnelker).
actress(spies_like_us, vanessa_angel, russian_rocket_crew).
actress(spies_like_us, svetlana_plotnikova, russian_rocket_crew).
actor(spies_like_us, bjarne_thomsen, russian_rocket_crew).
actor(spies_like_us, sergei_rousakov, russian_rocket_crew).
actor(spies_like_us, garrick_dombrovski, russian_rocket_crew).
actor(spies_like_us, terry_gilliam, dr_imhaus).
actor(spies_like_us, costa_gavras, tadzhik_highway_patrol).
actor(spies_like_us, seva_novgorodtsev, tadzhik_highway_patrol).
actor(spies_like_us, stephen_hoye, captain_hefling).
actor(spies_like_us, ray_harryhausen, dr_marston).
actor(spies_like_us, mark_stewart, ace_tomato_courier).
actor(spies_like_us, sean_daniel, ace_tomato_driver).
actor(spies_like_us, jeff_harding, fitz_hume_s_associate).
actress(spies_like_us, heidi_sorenson, alice_fitz_hume_s_supervisor).
actress(spies_like_us, margo_random, reporter).
actor(spies_like_us, douglas_lambert, reporter).
actor(spies_like_us, christopher_malcolm, jumpmaster).
actor(spies_like_us, terrance_conder, soldier_1).
actor(spies_like_us, matt_frewer, soldier_2).
actor(spies_like_us, tony_cyrus, the_khan).
actress(spies_like_us, gusti_bogok, dr_la_fong).
actor(spies_like_us, derek_meddings, dr_stinson).
actor(spies_like_us, robert_paynter, dr_gill).
actor(spies_like_us, bob_hope, golfer).
actor(spies_like_us, gurdial_sira, the_khan_s_brother).
actor(spies_like_us, joel_coen, drive_in_security).
actor(spies_like_us, sam_raimi, drive_in_security).
actor(spies_like_us, michael_apted, ace_tomato_agent).
actor(spies_like_us, b_b_king, ace_tomato_agent).
actor(spies_like_us, larry_cohen, ace_tomato_agent).
actor(spies_like_us, martin_brest, drive_in_security).
actor(spies_like_us, ricco_ross, wamp_guard).
actor(spies_like_us, richard_sharpe, wamp_technician).
actor(spies_like_us, stuart_milligan, wamp_technician).
actress(spies_like_us, sally_anlauf, wamp_technician).
actor(spies_like_us, john_daveikis, russian_border_guard).
actor(spies_like_us, laurence_bilzerian, russian_border_guard).
actor(spies_like_us, richard_kruk, russian_border_guard).
actress(spies_like_us, heather_henson, teenage_girl).
actress(spies_like_us, erin_folsey, teenage_girl).
actor(spies_like_us, bob_swaim, special_forces_commander).
actor(spies_like_us, edwin_newman, himself).
actress(spies_like_us, nancy_gair, student).

movie(star_wars_episode_i__the_phantom_menace, 1999).
director(star_wars_episode_i__the_phantom_menace, george_lucas).
actor(star_wars_episode_i__the_phantom_menace, liam_neeson, qui_gon_jinn).
actor(star_wars_episode_i__the_phantom_menace, ewan_mcgregor, obi_wan_kenobi).
actress(star_wars_episode_i__the_phantom_menace, natalie_portman, queen_padm_naberrie_amidala).
actor(star_wars_episode_i__the_phantom_menace, jake_lloyd, anakin_skywalker).
actress(star_wars_episode_i__the_phantom_menace, pernilla_august, shmi_skywalker).
actor(star_wars_episode_i__the_phantom_menace, frank_oz, yoda).
actor(star_wars_episode_i__the_phantom_menace, ian_mcdiarmid, senator_palpatine).
actor(star_wars_episode_i__the_phantom_menace, oliver_ford_davies, gov_sio_bibble).
actor(star_wars_episode_i__the_phantom_menace, hugh_quarshie, capt_panaka).
actor(star_wars_episode_i__the_phantom_menace, ahmed_best, jar_jar_binks).
actor(star_wars_episode_i__the_phantom_menace, anthony_daniels, c_3po).
actor(star_wars_episode_i__the_phantom_menace, kenny_baker, r2_d2).
actor(star_wars_episode_i__the_phantom_menace, terence_stamp, supreme_chancellor_valorum).
actor(star_wars_episode_i__the_phantom_menace, brian_blessed, boss_nass).
actor(star_wars_episode_i__the_phantom_menace, andrew_secombe, watto).
actor(star_wars_episode_i__the_phantom_menace, ray_park, darth_maul).
actor(star_wars_episode_i__the_phantom_menace, lewis_macleod, sebulba).
actor(star_wars_episode_i__the_phantom_menace, steven_spiers, capt_tarpals).
actor(star_wars_episode_i__the_phantom_menace, silas_carson, viceroy_nute_gunray_ki_adi_mundi_lott_dodd_radiant_vii_pilot).
actor(star_wars_episode_i__the_phantom_menace, ralph_brown, ric_oli).
actress(star_wars_episode_i__the_phantom_menace, celia_imrie, fighter_pilot_bravo_5).
actor(star_wars_episode_i__the_phantom_menace, benedict_taylor, fighter_pilot_bravo_2).
actor(star_wars_episode_i__the_phantom_menace, clarence_smith, fighter_pilot_bravo_3).
actress(star_wars_episode_i__the_phantom_menace, karol_cristina_da_silva, rab).
actor(star_wars_episode_i__the_phantom_menace, samuel_l_jackson, mace_windu).
actor(star_wars_episode_i__the_phantom_menace, dominic_west, palace_guard).
actress(star_wars_episode_i__the_phantom_menace, liz_wilson, eirta).
actress(star_wars_episode_i__the_phantom_menace, candice_orwell, yan).
actress(star_wars_episode_i__the_phantom_menace, sofia_coppola, sach).
actress(star_wars_episode_i__the_phantom_menace, keira_knightley, sab__queen_s_decoy).
actress(star_wars_episode_i__the_phantom_menace, bronagh_gallagher, radiant_vii_captain).
actor(star_wars_episode_i__the_phantom_menace, john_fensom, tc_14).
actor(star_wars_episode_i__the_phantom_menace, greg_proops, beed).
actor(star_wars_episode_i__the_phantom_menace, scott_capurro, fode).
actress(star_wars_episode_i__the_phantom_menace, margaret_towner, jira).
actor(star_wars_episode_i__the_phantom_menace, dhruv_chanchani, kitster).
actor(star_wars_episode_i__the_phantom_menace, oliver_walpole, seek).
actress(star_wars_episode_i__the_phantom_menace, katie_lucas, amee).
actress(star_wars_episode_i__the_phantom_menace, megan_udall, melee).
actor(star_wars_episode_i__the_phantom_menace, hassani_shapi, eeth_koth).
actress(star_wars_episode_i__the_phantom_menace, gin_clarke, adi_gallia).
actor(star_wars_episode_i__the_phantom_menace, khan_bonfils, saesee_tiin).
actress(star_wars_episode_i__the_phantom_menace, michelle_taylor, yarael_poof).
actress(star_wars_episode_i__the_phantom_menace, michaela_cottrell, even_piell).
actress(star_wars_episode_i__the_phantom_menace, dipika_o_neill_joti, depa_billaba).
actor(star_wars_episode_i__the_phantom_menace, phil_eason, yaddle).
actor(star_wars_episode_i__the_phantom_menace, mark_coulier, aks_moe).
actress(star_wars_episode_i__the_phantom_menace, lindsay_duncan, tc_14).
actor(star_wars_episode_i__the_phantom_menace, peter_serafinowicz, darth_maul).
actor(star_wars_episode_i__the_phantom_menace, james_taylor, rune_haako).
actor(star_wars_episode_i__the_phantom_menace, chris_sanders, daultay_dofine).
actor(star_wars_episode_i__the_phantom_menace, toby_longworth, sen_lott_dodd_gragra).
actor(star_wars_episode_i__the_phantom_menace, marc_silk, aks_moe).
actress(star_wars_episode_i__the_phantom_menace, amanda_lucas, tey_how).
actress(star_wars_episode_i__the_phantom_menace, amy_allen, twi_lek_senatorial_aide_dvd_deleted_scenes).
actor(star_wars_episode_i__the_phantom_menace, don_bies, pod_race_mechanic).
actress(star_wars_episode_i__the_phantom_menace, trisha_biggar, orn_free_taa_s_aide).
actor(star_wars_episode_i__the_phantom_menace, jerome_blake, rune_haako_mas_amedda_oppo_rancisis_orn_free_taa).
actress(star_wars_episode_i__the_phantom_menace, michonne_bourriague, aurra_sing).
actor(star_wars_episode_i__the_phantom_menace, ben_burtt, naboo_courier).
actor(star_wars_episode_i__the_phantom_menace, doug_chiang, flag_bearer).
actor(star_wars_episode_i__the_phantom_menace, rob_coleman, pod_race_spectator).
actor(star_wars_episode_i__the_phantom_menace, roman_coppola, senate_guard).
actor(star_wars_episode_i__the_phantom_menace, warwick_davis, wald_pod_race_spectator_mos_espa_citizen).
actor(star_wars_episode_i__the_phantom_menace, c_michael_easton, pod_race_spectator).
actor(star_wars_episode_i__the_phantom_menace, john_ellis, pod_race_spectator).
actor(star_wars_episode_i__the_phantom_menace, ira_feiedman, naboo_courier).
actor(star_wars_episode_i__the_phantom_menace, joss_gower, naboo_fighter_pilot).
actor(star_wars_episode_i__the_phantom_menace, raymond_griffiths, gonk_droid).
actor(star_wars_episode_i__the_phantom_menace, nathan_hamill, pod_race_spectator_naboo_palace_guard).
actor(star_wars_episode_i__the_phantom_menace, tim_harrington, extra_naboo_security_gaurd).
actress(star_wars_episode_i__the_phantom_menace, nifa_hindes, ann_gella).
actress(star_wars_episode_i__the_phantom_menace, nishan_hindes, tann_gella).
actor(star_wars_episode_i__the_phantom_menace, john_knoll, lt_rya_kirsch_bravo_4_flag_bearer).
actress(star_wars_episode_i__the_phantom_menace, madison_lloyd, princess_ellie).
actor(star_wars_episode_i__the_phantom_menace, dan_madsen, kaadu_handler).
actor(star_wars_episode_i__the_phantom_menace, iain_mccaig, orn_free_taa_s_aide).
actor(star_wars_episode_i__the_phantom_menace, rick_mccallum, naboo_courier).
actor(star_wars_episode_i__the_phantom_menace, lorne_peterson, mos_espa_citizen).
actor(star_wars_episode_i__the_phantom_menace, alan_ruscoe, plo_koon_bib_foruna_daultay_dofine).
actor(star_wars_episode_i__the_phantom_menace, steve_sansweet, naboo_courier).
actor(star_wars_episode_i__the_phantom_menace, jeff_shay, pod_race_spectator).
actor(star_wars_episode_i__the_phantom_menace, christian_simpson, bravo_6).
actor(star_wars_episode_i__the_phantom_menace, paul_martin_smith, naboo_courier).
actor(star_wars_episode_i__the_phantom_menace, scott_squires, naboo_speeder_driver).
actor(star_wars_episode_i__the_phantom_menace, tom_sylla, battle_droid).
actor(star_wars_episode_i__the_phantom_menace, danny_wagner, mawhonic).
actor(star_wars_episode_i__the_phantom_menace, dwayne_williams, naboo_courier).
actor(star_wars_episode_i__the_phantom_menace, matthew_wood, bib_fortuna_voice_of_ody_mandrell).
actor(star_wars_episode_i__the_phantom_menace, bob_woods, naboo_courier).

movie(torrance_rises, 1999).
director(torrance_rises, lance_bangs).
director(torrance_rises, spike_jonze).
director(torrance_rises, torrance_community_dance_group).
actor(torrance_rises, spike_jonze, richard_coufey).
actress(torrance_rises, michelle_adams_meeker, herself).
actress(torrance_rises, ashley_barnett, herself).
actress(torrance_rises, dee_buchanan, herself).
actor(torrance_rises, roman_coppola, roman_coppola).
actress(torrance_rises, sofia_coppola, herself).
actress(torrance_rises, renee_diamond, herself).
actor(torrance_rises, eminem, eminem).
actor(torrance_rises, alvin_gaines_molina, himself).
actress(torrance_rises, janeane_garofalo, janeane_garofalo).
actor(torrance_rises, michael_gier, himself).
actor(torrance_rises, richard_koufey, himself).
actor(torrance_rises, byron_s_loyd, himself).
actress(torrance_rises, allison_lynch, herself).
actress(torrance_rises, madonna, madonna).
actor(torrance_rises, kevin_l_maher, himself).
actor(torrance_rises, tony_maxwell, himself).
actress(torrance_rises, lonne_g_moretton, herself).
actress(torrance_rises, joyeve_palffy, herself).
actress(torrance_rises, kristine_petrucione, herself).
actor(torrance_rises, regis_philbin, regis_philbin).
actress(torrance_rises, cynthia_m_reed, herself).
actor(torrance_rises, chris_rock, chris_rock).
actor(torrance_rises, michael_rooney, michael_rooney).
actor(torrance_rises, justin_ross, himself).
actress(torrance_rises, danette_e_sheppard, herself).
actor(torrance_rises, fatboy_slim, fatboy_slim).
actor(torrance_rises, will_smith, will_smith).
actor(torrance_rises, frank_stancati, himself).
actor(torrance_rises, tim_szczepanski, himself).
actress(torrance_rises, michelle_weber, herself).

movie(the_usual_suspects, 1995).
director(the_usual_suspects, bryan_singer).
actor(the_usual_suspects, stephen_baldwin, michael_mcmanus).
actor(the_usual_suspects, gabriel_byrne, dean_keaton).
actor(the_usual_suspects, benicio_del_toro, fred_fenster).
actor(the_usual_suspects, kevin_pollak, todd_hockney).
actor(the_usual_suspects, kevin_spacey, roger_verbal_kint).
actor(the_usual_suspects, chazz_palminteri, dave_kujan_us_customs).
actor(the_usual_suspects, pete_postlethwaite, kobayashi).
actress(the_usual_suspects, suzy_amis, edie_finneran).
actor(the_usual_suspects, giancarlo_esposito, jack_baer_fbi).
actor(the_usual_suspects, dan_hedaya, sgt_geoffrey_jeff_rabin).
actor(the_usual_suspects, paul_bartel, smuggler).
actor(the_usual_suspects, carl_bressler, saul_berg).
actor(the_usual_suspects, phillip_simon, fortier).
actor(the_usual_suspects, jack_shearer, renault).
actress(the_usual_suspects, christine_estabrook, dr_plummer).
actor(the_usual_suspects, clark_gregg, dr_walters).
actor(the_usual_suspects, morgan_hunter, arkosh_kovash).
actor(the_usual_suspects, ken_daly, translator).
actress(the_usual_suspects, michelle_clunie, sketch_artist).
actor(the_usual_suspects, louis_lombardi, strausz).
actor(the_usual_suspects, frank_medrano, rizzi).
actor(the_usual_suspects, ron_gilbert, daniel_metzheiser_dept_of_justice).
actor(the_usual_suspects, vito_d_ambrosio, arresting_officer).
actor(the_usual_suspects, gene_lythgow, cop_on_pier).
actor(the_usual_suspects, robert_elmore, bodyguard_1).
actor(the_usual_suspects, david_powledge, bodyguard_2).
actor(the_usual_suspects, bob_pennetta, bodyguard_3).
actor(the_usual_suspects, billy_bates, bodyguard_4).
actress(the_usual_suspects, smadar_hanson, keyser_s_wife).
actor(the_usual_suspects, castulo_guerra, arturro_marquez).
actor(the_usual_suspects, peter_rocca, jaime_arturro_s_bodyguard).
actor(the_usual_suspects, bert_williams, old_cop_in_property).
actor(the_usual_suspects, john_gillespie, '').
actor(the_usual_suspects, peter_greene, redfoot_the_fence).
actor(the_usual_suspects, christopher_mcquarrie, interrogation_cop).
actor(the_usual_suspects, scott_b_morgan, keyser_s_ze_in_flashback).

movie(the_virgin_suicides, 1999).
director(the_virgin_suicides, sofia_coppola).
actor(the_virgin_suicides, james_woods, mr_lisbon).
actress(the_virgin_suicides, kathleen_turner, mrs_lisbon).
actress(the_virgin_suicides, kirsten_dunst, lux_lisbon).
actor(the_virgin_suicides, josh_hartnett, trip_fontaine).
actor(the_virgin_suicides, michael_par, adult_trip_fontaine).
actor(the_virgin_suicides, scott_glenn, father_moody).
actor(the_virgin_suicides, danny_devito, dr_horniker).
actress(the_virgin_suicides, a_j_cook, mary_lisbon).
actress(the_virgin_suicides, hanna_r_hall, cecilia_lisbon).
actress(the_virgin_suicides, leslie_hayman, therese_lisbon).
actress(the_virgin_suicides, chelse_swain, bonnie_lisbon).
actor(the_virgin_suicides, anthony_desimone, chase_buell).
actor(the_virgin_suicides, lee_kagan, david_barker).
actor(the_virgin_suicides, robert_schwartzman, paul_baldino).
actor(the_virgin_suicides, noah_shebib, parkie_denton).
actor(the_virgin_suicides, jonathan_tucker, tim_weiner).
actor(the_virgin_suicides, joe_roncetti, kevin_head).
actor(the_virgin_suicides, hayden_christensen, joe_hill_conley).
actor(the_virgin_suicides, chris_hale, peter_sisten).
actor(the_virgin_suicides, joe_dinicol, dominic_palazzolo).
actress(the_virgin_suicides, suki_kaiser, lydia_perl).
actress(the_virgin_suicides, dawn_greenhalgh, mrs_scheer).
actor(the_virgin_suicides, allen_stewart_coates, mr_scheer).
actress(the_virgin_suicides, sherry_miller, mrs_buell).
actor(the_virgin_suicides, jonathon_whittaker, mr_buell).
actress(the_virgin_suicides, michelle_duquet, mrs_denton).
actor(the_virgin_suicides, murray_mcrae, mr_denton).
actress(the_virgin_suicides, roberta_hanley, mrs_weiner).
actor(the_virgin_suicides, paul_sybersma, joe_larson).
actress(the_virgin_suicides, susan_sybersma, mrs_larson).
actor(the_virgin_suicides, peter_snider, trip_s_dad).
actor(the_virgin_suicides, gary_brennan, donald).
actor(the_virgin_suicides, charles_boyland, curt_van_osdol).
actor(the_virgin_suicides, dustin_ladd, chip_willard).
actress(the_virgin_suicides, kristin_fairlie, amy_schraff).
actress(the_virgin_suicides, melody_johnson, julie).
actress(the_virgin_suicides, sheyla_molho, danielle).
actress(the_virgin_suicides, ashley_ainsworth, sheila_davis).
actress(the_virgin_suicides, courtney_hawkrigg, grace).
actor(the_virgin_suicides, fran_ois_klanfer, doctor).
actor(the_virgin_suicides, mackenzie_lawrenz, jim_czeslawski).
actor(the_virgin_suicides, tim_hall, kurt_siles).
actor(the_virgin_suicides, amos_crawley, john).
actor(the_virgin_suicides, andrew_gillies, principal_woodhouse).
actress(the_virgin_suicides, marilyn_smith, mrs_woodhouse).
actress(the_virgin_suicides, sally_cahill, mrs_hedlie).
actress(the_virgin_suicides, tracy_ferencz, nurse).
actor(the_virgin_suicides, scot_denton, mr_o_conner).
actress(the_virgin_suicides, catherine_swing, mrs_o_conner).
actor(the_virgin_suicides, timothy_adams, buzz_romano).
actor(the_virgin_suicides, michael_michaelessi, parks_department_foreman).
actress(the_virgin_suicides, sarah_minhas, wanda_brown).
actress(the_virgin_suicides, megan_kennedy, cheerleader).
actress(the_virgin_suicides, sandi_stahlbrand, meredith_thompson).
actor(the_virgin_suicides, neil_girvan, drunk_man_in_pool).
actress(the_virgin_suicides, jaya_karsemeyer, gloria).
actress(the_virgin_suicides, leah_straatsma, rannie).
actor(the_virgin_suicides, mark_polley, cemetery_worker_1).
actor(the_virgin_suicides, kirk_gonnsen, cemetery_worker_2).
actress(the_virgin_suicides, marianne_moroney, teacher).
actress(the_virgin_suicides, anne_wessels, woman_in_chiffon).
actor(the_virgin_suicides, derek_boyes, football_grieving_teacher).
actor(the_virgin_suicides, john_buchan, john_lydia_s_boss).
actress(the_virgin_suicides, mandy_lee_jones, student).
actor(the_virgin_suicides, giovanni_ribisi, narrator).

movie(an_american_rhapsody, 2001).
director(an_american_rhapsody, va_g_rdos).
actress(an_american_rhapsody, scarlett_johansson, suzanne_sandor_at_15).
actress(an_american_rhapsody, nastassja_kinski, margit_sandor).
actress(an_american_rhapsody, raffaella_b_ns_gi, suzanne_infant).
actor(an_american_rhapsody, tony_goldwyn, peter_sandor).
actress(an_american_rhapsody, gnes_b_nfalvy, helen).
actor(an_american_rhapsody, zolt_n_seress, george).
actress(an_american_rhapsody, klaudia_szab, maria_at_4).
actor(an_american_rhapsody, zsolt_zagoni, russian_soldier).
actor(an_american_rhapsody, andr_s_sz_ke, istvan).
actress(an_american_rhapsody, erzsi_p_sztor, ilus).
actor(an_american_rhapsody, carlos_laszlo_weiner, boy_on_train_boy_at_party).
actress(an_american_rhapsody, bori_kereszturi, suzanne_at_3).
actor(an_american_rhapsody, p_ter_k_lloy_moln_r, avo_officer).
actress(an_american_rhapsody, zsuzsa_czink_czi, teri).
actor(an_american_rhapsody, bal_zs_galk, jeno).
actress(an_american_rhapsody, kata_dob, claire).
actress(an_american_rhapsody, va_sz_r_nyi, eva).
actor(an_american_rhapsody, don_pugsley, cafe_supervisor).
actor(an_american_rhapsody, vladimir_mashkov, frank).
actress(an_american_rhapsody, lisa_jane_persky, pattie).
actress(an_american_rhapsody, colleen_camp, dottie).
actress(an_american_rhapsody, kelly_endresz_banlaki, suzanne_at_6).
actress(an_american_rhapsody, imola_g_sp_r, stewardess).
actress(an_american_rhapsody, tatyana_kanavka, girl_in_airport).
actress(an_american_rhapsody, mae_whitman, maria_at_10).
actress(an_american_rhapsody, lorna_scott, neighbor_with_poodle).
actress(an_american_rhapsody, sandra_staggs, saleswoman).
actress(an_american_rhapsody, jacqueline_steiger, betty).
actor(an_american_rhapsody, robert_lesser, harold).
actor(an_american_rhapsody, lou_beach, party_goer).
actress(an_american_rhapsody, marlee_jackson, sheila_at_7).
actress(an_american_rhapsody, emmy_rossum, sheila_at_15).
actor(an_american_rhapsody, timothy_everett_moore, paul).
actor(an_american_rhapsody, joshua_dov, richard).
actress(an_american_rhapsody, larisa_oleynik, maria_sandor_at_18).
actress(an_american_rhapsody, kati_b_cs, woman_1_at_market).
actress(an_american_rhapsody, zsuzsa_sz_ger, woman_2_at_market).
actor(an_american_rhapsody, andras_banlaki, '').
actress(an_american_rhapsody, va_g_rdos, suzanne_sandor_in_family_picture_age_6).
actor(an_american_rhapsody, peter_janosi, german_customs_officer).

movie(the_black_dahlia, 2006).
director(the_black_dahlia, brian_de_palma).
actor(the_black_dahlia, josh_hartnett, ofcr_dwight_bucky_bleichert).
actress(the_black_dahlia, scarlett_johansson, kay_lake).
actress(the_black_dahlia, hilary_swank, madeleine_linscott).
actor(the_black_dahlia, aaron_eckhart, sgt_leland_lee_blanchard).
actress(the_black_dahlia, mia_kirshner, elizabeth_short).
actor(the_black_dahlia, graham_norris, sgt_john_carter).
actress(the_black_dahlia, judith_benezra, '').
actor(the_black_dahlia, richard_brake, bobby_dewitt).
actor(the_black_dahlia, kevin_dunn, cleo_short).
actor(the_black_dahlia, troy_evans, '').
actor(the_black_dahlia, william_finley, '').
actor(the_black_dahlia, patrick_fischler, a_d_a_ellis_loew).
actor(the_black_dahlia, michael_p_flannigan, desk_sergeant).
actor(the_black_dahlia, gregg_henry, '').
actress(the_black_dahlia, claudia_katz, frolic_bartender).
actor(the_black_dahlia, john_kavanagh, emmet_linscott).
actress(the_black_dahlia, laura_kightlinger, hooker).
actor(the_black_dahlia, steven_koller, male_nurse).
actor(the_black_dahlia, angus_macinnes, '').
actor(the_black_dahlia, david_mcdivitt, cop).
actress(the_black_dahlia, rose_mcgowan, sheryl_saddon).
actor(the_black_dahlia, victor_mcguire, '').
actress(the_black_dahlia, rachel_miner, '').
actress(the_black_dahlia, stephanie_l_moore, pretty_girl).
actor(the_black_dahlia, james_otis, '').
actor(the_black_dahlia, david_raibon, black_man).
actress(the_black_dahlia, jemima_rooper, '').
actor(the_black_dahlia, anthony_russell, '').
actor(the_black_dahlia, joost_scholte, gi_pick_up).
actor(the_black_dahlia, pepe_serna, '').
actress(the_black_dahlia, fiona_shaw, '').
actor(the_black_dahlia, joey_slotnick, '').
actor(the_black_dahlia, mike_starr, russ_millard).

movie(fall, 1997).
director(fall, eric_schaeffer).
actor(fall, eric_schaeffer, michael).
actress(fall, amanda_de_cadenet, sarah).
actor(fall, rudolf_martin, phillipe).
actress(fall, francie_swift, robin).
actress(fall, lisa_vidal, sally).
actress(fall, roberta_maxwell, joan_alterman).
actor(fall, jose_yenque, scasse).
actor(fall, josip_kuchan, zsarko).
actress(fall, scarlett_johansson, little_girl).
actress(fall, ellen_barber, woman).
actor(fall, willis_burks_ii, baja).
actor(fall, scott_cohen, derick).
actor(fall, a_j_lopez, bellboy).
actor(fall, casper_martinez, church_goer).
actor(fall, arthur_j_nascarella, anthony_the_maitre_d).
actor(fall, john_o_nelson, guy_by_window).
actor(fall, amaury_nolasco, waiter).
actor(fall, marc_sebastian, popparazi).
actor(fall, evan_thompson, priest).
actor(fall, larry_weiss, paparazzi).

movie(eight_legged_freaks, 2002).
director(eight_legged_freaks, ellory_elkayem).
actor(eight_legged_freaks, david_arquette, chris_mccormick).
actress(eight_legged_freaks, kari_wuhrer, sheriff_samantha_parker).
actor(eight_legged_freaks, scott_terra, mike_parker).
actress(eight_legged_freaks, scarlett_johansson, ashley_parker).
actor(eight_legged_freaks, doug_e_doug, harlan_griffith).
actor(eight_legged_freaks, rick_overton, deputy_pete_willis).
actor(eight_legged_freaks, leon_rippy, wade).
actor(eight_legged_freaks, matt_czuchry, bret).
actor(eight_legged_freaks, jay_arlen_jones, leon).
actress(eight_legged_freaks, eileen_ryan, gladys).
actor(eight_legged_freaks, riley_smith, randy).
actor(eight_legged_freaks, matt_holwick, larry).
actress(eight_legged_freaks, jane_edith_wilson, emma).
actor(eight_legged_freaks, jack_moore, amos).
actor(eight_legged_freaks, roy_gaintner, floyd).
actor(eight_legged_freaks, don_champlin, leroy).
actor(eight_legged_freaks, john_storey, mark).
actor(eight_legged_freaks, david_earl_waterman, norman).
actress(eight_legged_freaks, randi_j_klein, waitress_1).
actress(eight_legged_freaks, terey_summers, waitress_2).
actor(eight_legged_freaks, john_ennis, cop_1).
actor(eight_legged_freaks, ryan_c_benson, cop_2).
actor(eight_legged_freaks, bruiser, himself).
actor(eight_legged_freaks, tom_noonan, joshua_taft).

movie(ghost_world, 2000).
director(ghost_world, terry_zwigoff).
actress(ghost_world, thora_birch, enid).
actress(ghost_world, scarlett_johansson, rebecca).
actor(ghost_world, steve_buscemi, seymour).
actor(ghost_world, brad_renfro, josh).
actress(ghost_world, illeana_douglas, roberta_allsworth).
actor(ghost_world, bob_balaban, enid_s_dad).
actress(ghost_world, stacey_travis, dana).
actor(ghost_world, charles_c_stevenson_jr, norman).
actor(ghost_world, dave_sheridan, doug).
actor(ghost_world, tom_mcgowan, joe).
actress(ghost_world, debra_azar, melora).
actor(ghost_world, brian_george, sidewinder_boss).
actor(ghost_world, pat_healy, john_ellis).
actress(ghost_world, rini_bell, graduation_speaker).
actor(ghost_world, t_j_thyne, todd).
actor(ghost_world, ezra_buzzington, weird_al).
actress(ghost_world, lindsey_girardot, vanilla__graduation_rapper).
actress(ghost_world, joy_bisco, jade__graduation_rapper).
actress(ghost_world, venus_demilo, ebony__graduation_rapper).
actress(ghost_world, ashley_peldon, margaret__art_class).
actor(ghost_world, chachi_pittman, phillip__art_class).
actress(ghost_world, janece_jordan, black_girl__art_class).
actress(ghost_world, kaileigh_martin, snotty_girl__art_class).
actor(ghost_world, alexander_fors, hippy_boy__art_class).
actor(ghost_world, marc_vann, jerome_the_angry_guy__record_collector).
actor(ghost_world, james_sie, steven_the_asian_guy__record_collector).
actor(ghost_world, paul_keith, paul_the_fussy_guy__record_collector).
actor(ghost_world, david_cross, gerrold_the_pushy_guy__record_collector).
actor(ghost_world, j_j_bad_boy_jones, fred_chatman__blues_club).
actress(ghost_world, dylan_jones, red_haired_girl__blues_club).
actor(ghost_world, martin_grey, m_c__blues_club).
actor(ghost_world, steve_pierson, blueshammer_member__blues_club).
actor(ghost_world, jake_la_botz, blueshammer_member__blues_club).
actor(ghost_world, johnny_irion, blueshammer_member__blues_club).
actor(ghost_world, nate_wood, blueshammer_member__blues_club).
actor(ghost_world, charles_schneider, joey_mccobb_the_stand_up_comic).
actor(ghost_world, sid_hillman, zine_o_phobia_creep).
actor(ghost_world, joshua_wheeler, zine_o_phobia_creep).
actor(ghost_world, patrick_fischler, masterpiece_video_clerk).
actor(ghost_world, daniel_graves, masterpiece_video_customer).
actor(ghost_world, matt_doherty, masterpiece_video_employee).
actor(ghost_world, joel_michaely, porno_cashier).
actress(ghost_world, debi_derryberry, rude_coffee_customer).
actor(ghost_world, joseph_sikora, reggae_fan).
actor(ghost_world, brett_gilbert, alien_autopsy_guy).
actor(ghost_world, alex_solowitz, cineplex_manager).
actor(ghost_world, tony_ketcham, alcoholic_customer).
actress(ghost_world, mary_bogue, popcorn_customer).
actor(ghost_world, brian_jacobs, soda_customer).
actor(ghost_world, patrick_yonally, garage_sale_hipster).
actress(ghost_world, lauren_bowles, angry_garage_sale_woman).
actress(ghost_world, lorna_scott, phyllis_the_art_show_curator).
actor(ghost_world, jeff_murray, roberta_s_colleague).
actor(ghost_world, jerry_rector, dana_s_co_worker).
actor(ghost_world, john_bunnell, seymour_s_boss).
actress(ghost_world, diane_salinger, psychiatrist).
actress(ghost_world, anna_berger, seymour_s_mother).
actor(ghost_world, bruce_glover, feldman_the_wheel_chair_guy).
actress(ghost_world, joan_m_blair, lady_crossing_street_slowly).
actor(ghost_world, michael_chanslor, orange_colored_sky_keyboarder_graduation_band).
actress(ghost_world, teri_garr, maxine).
actor(ghost_world, alan_heitz, driver).
actor(ghost_world, ernie_hernandez, orange_colored_sky_guitarist_graduation_band).
actor(ghost_world, felice_hernandez, orange_colored_sky_singer_graduation_band).
actor(ghost_world, larry_klein, orange_colored_sky_drummer_graduation_band).
actor(ghost_world, james_matusky, reggae_fan_2).
actor(ghost_world, edward_t_mcavoy, mr_satanist).
actress(ghost_world, margaret_kontra_palmer, lady_at_garage_sale).
actor(ghost_world, larry_parker, orange_colored_sky_bassist_graduation_band).
actor(ghost_world, greg_wendell_reid, yuppie_1).
actress(ghost_world, michelle_marie_white, mom_in_convenience_store).
actor(ghost_world, peter_yarrow, himself).

movie(a_good_woman, 2004).
director(a_good_woman, mike_barker).
actress(a_good_woman, helen_hunt, mrs_erlynne).
actress(a_good_woman, scarlett_johansson, meg_windermere).
actress(a_good_woman, milena_vukotic, contessa_lucchino).
actor(a_good_woman, stephen_campbell_moore, lord_darlington).
actor(a_good_woman, mark_umbers, robert_windemere).
actor(a_good_woman, roger_hammond, cecil).
actor(a_good_woman, john_standing, dumby).
actor(a_good_woman, tom_wilkinson, tuppy).
actress(a_good_woman, giorgia_massetti, alessandra).
actress(a_good_woman, diana_hardcastle, lady_plymdale).
actress(a_good_woman, shara_orano, francesca).
actress(a_good_woman, jane_how, mrs_stutfield).
actor(a_good_woman, bruce_mcguire, waiter_joe).
actor(a_good_woman, michael_stromme, hotel_desk_clerk).
actor(a_good_woman, antonio_barbaro, paulo).
actress(a_good_woman, valentina_d_uva, giuseppina_glove_shop_girl).
actor(a_good_woman, filippo_santoro, old_man).
actor(a_good_woman, augusto_zucchi, antique_shop_keeper).
actress(a_good_woman, carolina_levi, dress_shop_salesgirl).
actress(a_good_woman, daniela_stanga, dress_shop_owner).
actress(a_good_woman, arianna_mansi, stella_s_maid_1).
actress(a_good_woman, camilla_bertocci, stella_s_maid_2).
actress(a_good_woman, nichola_aigner, mrs_gowper).

movie(if_lucy_fell, 1996).
director(if_lucy_fell, eric_schaeffer).
actress(if_lucy_fell, sarah_jessica_parker, lucy_ackerman).
actor(if_lucy_fell, eric_schaeffer, joe_macgonaughgill).
actor(if_lucy_fell, ben_stiller, bwick_elias).
actress(if_lucy_fell, elle_macpherson, jane_lindquist).
actor(if_lucy_fell, james_rebhorn, simon_ackerman).
actor(if_lucy_fell, robert_john_burke, handsome_man).
actor(if_lucy_fell, david_thornton, ted).
actor(if_lucy_fell, bill_sage, dick).
actor(if_lucy_fell, dominic_chianese, al).
actress(if_lucy_fell, scarlett_johansson, emily).
actor(if_lucy_fell, michael_storms, sam).
actor(if_lucy_fell, jason_myers, billy).
actress(if_lucy_fell, emily_hart, eddy).
actor(if_lucy_fell, paul_greco, rene).
actor(if_lucy_fell, mujibur_rahman, counterman).
actor(if_lucy_fell, sirajul_islam, counterman).
actor(if_lucy_fell, ben_lin, chinese_messenger).
actress(if_lucy_fell, alice_spivak, elegant_middle_aged_woman).
actress(if_lucy_fell, lisa_gerstein, saleswoman).
actress(if_lucy_fell, molly_schulman, kid).
actor(if_lucy_fell, peter_walker, bag_man).
actor(if_lucy_fell, bradley_jenkel, neighbor).
actor(if_lucy_fell, brian_keane, man_in_gallery).
actress(if_lucy_fell, amanda_kravat, woman_in_park).

movie(home_alone_3, 1997).
director(home_alone_3, raja_gosnell).
actor(home_alone_3, alex_d_linz, alex_pruitt).
actor(home_alone_3, olek_krupa, peter_beaupre).
actress(home_alone_3, rya_kihlstedt, alice_ribbons).
actor(home_alone_3, lenny_von_dohlen, burton_jernigan).
actor(home_alone_3, david_thornton, earl_unger).
actress(home_alone_3, haviland_morris, karen_pruitt).
actor(home_alone_3, kevin_kilner, jack_pruitt).
actress(home_alone_3, marian_seldes, mrs_hess).
actor(home_alone_3, seth_smith, stan_pruitt).
actress(home_alone_3, scarlett_johansson, molly_pruitt).
actor(home_alone_3, christopher_curry, agent_stuckey).
actor(home_alone_3, baxter_harris, police_captain).
actor(home_alone_3, james_saito, chinese_mob_boss).
actor(home_alone_3, kevin_gudahl, techie).
actor(home_alone_3, richard_hamilton, taxi_driver).
actor(home_alone_3, freeman_coffey, recruiting_officer).
actress(home_alone_3, krista_lally, dispatcher).
actor(home_alone_3, neil_flynn, police_officer_1).
actor(home_alone_3, tony_mockus_jr, police_officer_2).
actor(home_alone_3, pat_healy, agent_rogers).
actor(home_alone_3, james_chisem, police_officer_3).
actor(home_alone_3, darwin_harris, photographer).
actress(home_alone_3, adrianne_duncan, flight_attendant).
actress(home_alone_3, sharon_sachs, annoying_woman).
actor(home_alone_3, joseph_luis_caballero, security_guard).
actor(home_alone_3, larry_c_tankson, cart_driver).
actress(home_alone_3, jennifer_a_daley, police_photographer_2).
actor(home_alone_3, darren_t_knaus, parrot).
actress(home_alone_3, caryn_cheever, ticketing_agent).
actress(home_alone_3, sarah_godshaw, latchkey_girl).
actor(home_alone_3, andy_john_g_kalkounos, police_officer_1).
actor(home_alone_3, zachary_lee, johnny_allen).
actress(home_alone_3, kelly_ann_marquart, girl_on_sidewalk).

movie(the_horse_whisperer, 1998).
director(the_horse_whisperer, robert_redford).
actor(the_horse_whisperer, robert_redford, tom_booker).
actress(the_horse_whisperer, kristin_scott_thomas, annie_maclean).
actor(the_horse_whisperer, sam_neill, robert_maclean).
actress(the_horse_whisperer, dianne_wiest, diane_booker).
actress(the_horse_whisperer, scarlett_johansson, grace_maclean).
actor(the_horse_whisperer, chris_cooper, frank_booker).
actress(the_horse_whisperer, cherry_jones, liz_hammond).
actor(the_horse_whisperer, ty_hillman, joe_booker).
actress(the_horse_whisperer, kate_bosworth, judith).
actor(the_horse_whisperer, austin_schwarz, twin_1).
actor(the_horse_whisperer, dustin_schwarz, twin_2).
actress(the_horse_whisperer, jeanette_nolan, ellen_booker).
actor(the_horse_whisperer, steve_frye, hank).
actor(the_horse_whisperer, don_edwards, smokey).
actress(the_horse_whisperer, jessalyn_gilsig, lucy_annie_s_assistant).
actor(the_horse_whisperer, william_buddy_byrd, lester_petersen).
actor(the_horse_whisperer, john_hogarty, local_tracker).
actor(the_horse_whisperer, michel_lalonde, park_ranger).
actor(the_horse_whisperer, c_j_byrnes, doctor).
actress(the_horse_whisperer, kathy_baldwin_keenan, nurse_1).
actress(the_horse_whisperer, allison_moorer, barn_dance_vocalist).
actor(the_horse_whisperer, george_a_sack_jr, truck_driver).
actress(the_horse_whisperer, kellee_sweeney, nurse_2).
actor(the_horse_whisperer, stephen_pearlman, david_gottschalk).
actress(the_horse_whisperer, joelle_carter, office_worker_1).
actress(the_horse_whisperer, sunny_chae, office_worker_2).
actress(the_horse_whisperer, anne_joyce, office_worker_3).
actress(the_horse_whisperer, tara_sobeck, schoolgirl_1).
actress(the_horse_whisperer, kristy_ann_servidio, schoolgirl_2).
actress(the_horse_whisperer, marie_engle, neighbor).
actor(the_horse_whisperer, curt_pate, handsome_cowboy).
actor(the_horse_whisperer, steven_brian_conard, ranch_hand).
actress(the_horse_whisperer, tammy_pate, roper).
actress(the_horse_whisperer, gloria_lynne_henry, member_of_magazine_staff).
actor(the_horse_whisperer, lance_r_jones, ranch_hand).
actor(the_horse_whisperer, donnie_saylor, rugged_cowboy).
actor(the_horse_whisperer, george_strait, himself).

movie(in_good_company, 2004).
director(in_good_company, paul_weitz).
actor(in_good_company, dennis_quaid, dan_foreman).
actor(in_good_company, topher_grace, carter_duryea).
actress(in_good_company, scarlett_johansson, alex_foreman).
actress(in_good_company, marg_helgenberger, ann_foreman).
actor(in_good_company, david_paymer, morty).
actor(in_good_company, clark_gregg, mark_steckle).
actor(in_good_company, philip_baker_hall, eugene_kalb).
actress(in_good_company, selma_blair, kimberly).
actor(in_good_company, frankie_faison, corwin).
actor(in_good_company, ty_burrell, enrique_colon).
actor(in_good_company, kevin_chapman, lou).
actress(in_good_company, amy_aquino, alicia).
actress(in_good_company, zena_grey, jana_foreman).
actress(in_good_company, colleen_camp, receptionist).
actress(in_good_company, lauren_tom, obstetrician).
actor(in_good_company, ron_bottitta, porsche_dealer).
actor(in_good_company, jon_collin, waiter).
actor(in_good_company, shishir_kurup, maitre_d).
actor(in_good_company, tim_edward_rhoze, theo).
actor(in_good_company, enrique_castillo, hector).
actor(in_good_company, john_cho, petey).
actor(in_good_company, chris_ausnit, young_executive).
actress(in_good_company, francesca_roberts, loan_officer).
actor(in_good_company, gregory_north, lawyer).
actor(in_good_company, gregory_hinton, moving_man).
actor(in_good_company, todd_lyon, moving_man).
actor(in_good_company, thomas_j_dooley, moving_man).
actor(in_good_company, robin_t_kirksey, basketball_ringer).
actress(in_good_company, katherine_ellis, maya__roommate).
actor(in_good_company, nick_schutt, carter_s_assistant).
actor(in_good_company, john_kepley, salesman).
actor(in_good_company, mobin_khan, salesman).
actress(in_good_company, jeanne_kort, saleswoman).
actor(in_good_company, dean_a_parker, mike).
actor(in_good_company, richard_hotson, fired_employee).
actress(in_good_company, shar_washington, fired_employee).
actress(in_good_company, rebecca_hedrick, teddy_k_s_assistant).
actor(in_good_company, miguel_arteta, globecom_technician).
actor(in_good_company, sam_tippe, kid_at_party).
actress(in_good_company, roma_torre, anchorwoman).
actor(in_good_company, andre_cablayan, legally_dedd).
actor(in_good_company, dante_powell, legally_dedd).
actress(in_good_company, michalina_almindo, hector_s_date).
actor(in_good_company, bennett_andrews, greensman).
actress(in_good_company, claudia_barroso, bar_patron).
actress(in_good_company, jaclynn_tiffany_brown, basketball_player).
actor(in_good_company, malcolm_mcdowell, teddy_k__globecom_ceo).
actor(in_good_company, scott_sahadi, moving_man).
actress(in_good_company, loretta_shenosky, kalb_s_assistant).
actor(in_good_company, trevor_stynes, man_on_street).

movie(just_cause, 1995).
director(just_cause, arne_glimcher).
actor(just_cause, sean_connery, paul_armstrong).
actor(just_cause, laurence_fishburne, sheriff_tanny_brown).
actress(just_cause, kate_capshaw, laurie_armstrong).
actor(just_cause, blair_underwood, bobby_earl).
actor(just_cause, ed_harris, blair_sullivan).
actor(just_cause, christopher_murray, detective_t_j_wilcox).
actress(just_cause, ruby_dee, evangeline).
actress(just_cause, scarlett_johansson, kate_armstrong).
actor(just_cause, daniel_j_travanti, warden).
actor(just_cause, ned_beatty, mcnair).
actress(just_cause, liz_torres, delores_rodriguez).
actress(just_cause, lynne_thigpen, ida_conklin).
actress(just_cause, taral_hicks, lena_brown).
actor(just_cause, victor_slezak, sgt_rogers).
actor(just_cause, kevin_mccarthy, phil_prentiss).
actress(just_cause, hope_lange, libby_prentiss).
actor(just_cause, chris_sarandon, lyle_morgan).
actor(just_cause, george_plimpton, elder_phillips).
actress(just_cause, brooke_alderson, dr_doliveau).
actress(just_cause, colleen_fitzpatrick, prosecutor).
actor(just_cause, richard_liberty, chaplin).
actor(just_cause, joel_s_ehrenkranz, judge).
actress(just_cause, barbara_jean_kane, joanie_shriver).
actor(just_cause, maurice_jamaal_brown, reese_brown).
actor(just_cause, patrick_maycock, kid_washing_car_1).
actor(just_cause, jordan_f_vaughn, kid_washing_car_2).
actor(just_cause, francisco_paz, concierge).
actress(just_cause, marie_hyman, clerk).
actor(just_cause, s_bruce_wilson, party_guest).
actor(just_cause, erik_stephan, student).
actress(just_cause, melanie_hughes, receptionist).
actress(just_cause, megan_meinardus, slumber_party_girl).
actress(just_cause, melissa_hood_julien, slumber_party_girl).
actress(just_cause, jenna_del_buono, slumber_party_girl).
actress(just_cause, ashley_popelka, slumber_party_girl).
actress(just_cause, marisa_perry, slumber_party_girl).
actress(just_cause, ashley_council, slumber_party_girl).
actress(just_cause, augusta_lundsgaard, slumber_party_girl).
actress(just_cause, connie_lee_brown, prison_guard).
actor(just_cause, clarence_lark_iii, prison_guard).
actor(just_cause, monte_st_james, prisoner).
actor(just_cause, gary_landon_mills, prisoner).
actor(just_cause, shareef_malnik, prisoner).
actor(just_cause, tony_bolano, prisoner).
actor(just_cause, angelo_maldonado, prisoner).
actor(just_cause, fausto_rodriguez, prisoner).
actress(just_cause, karen_leeds, reporter).
actor(just_cause, dan_romero, reporter).
actor(just_cause, donn_lamkin, reporter).
actress(just_cause, stacie_a_zinn, reporter).
actress(just_cause, kylie_delre, woman_in_courtroom).
actress(just_cause, deborah_smith_ford, medical_examiner).
actor(just_cause, patrick_fullerton, reporter).
actor(just_cause, jody_millard, prison_guard).
actor(just_cause, michael_sassano, courtroom_observer).
actor(just_cause, rene_teboe, man_in_bus_terminal).

movie(the_island, 2005).
director(the_island, michael_bay).
actor(the_island, ewan_mcgregor, lincoln_six_echo_tom_lincoln).
actress(the_island, scarlett_johansson, jordan_two_delta_sarah_jordan).
actor(the_island, djimon_hounsou, albert_laurent).
actor(the_island, sean_bean, merrick).
actor(the_island, steve_buscemi, mccord).
actor(the_island, michael_clarke_duncan, starkweather).
actor(the_island, ethan_phillips, jones_three_echo).
actor(the_island, brian_stepanek, gandu_three_echo).
actress(the_island, noa_tishby, community_announcer).
actress(the_island, siobhan_flynn, lima_one_alpha).
actor(the_island, troy_blendell, laurent_team_member).
actor(the_island, jamie_mcbride, laurent_team_member).
actor(the_island, kevin_mccorkle, laurent_team_member).
actor(the_island, gary_nickens, laurent_team_member).
actress(the_island, kathleen_rose_perkins, laurent_team_member).
actor(the_island, richard_whiten, laurent_team_member).
actor(the_island, max_baker, carnes).
actor(the_island, phil_abrams, harvest_doctor).
actress(the_island, svetlana_efremova, harvest_midwife).
actress(the_island, katy_boyer, harvest_surgeon).
actor(the_island, randy_oglesby, harvest_surgeon).
actress(the_island, yvette_nicole_brown, harvest_nurse).
actress(the_island, taylor_gilbert, harvest_nurse).
actress(the_island, wendy_haines, harvest_nurse).
actor(the_island, tim_halligan, institute_coroner).
actor(the_island, glenn_morshower, medical_courier).
actor(the_island, michael_canavan, extraction_room_doctor).
actor(the_island, jimmy_smagula, extraction_room_technician).
actor(the_island, ben_tolpin, extraction_room_technician).
actor(the_island, robert_sherman, agnate_in_pod).
actor(the_island, rich_hutchman, dept_of_operations_supervisor).
actor(the_island, gonzalo_menendez, dept_of_operations_technician).
actress(the_island, olivia_tracey, dept_of_operations_agnate).
actor(the_island, ray_xifo, elevator_agnate).
actress(the_island, mary_pat_gleason, nutrition_clerk).
actress(the_island, ashley_yegan, stim_bar_bartender).
actress(the_island, whitney_dylan, client_services_operator).
actress(the_island, mitzi_martin, atrium_tour_guide).
actor(the_island, lewis_dauber, tour_group_man).
actress(the_island, shelby_leverington, tour_group_woman).
actor(the_island, don_creech, god_like_man).
actor(the_island, richard_v_licata, board_member).
actor(the_island, eamon_behrens, censor).
actor(the_island, alex_carter, censor).
actor(the_island, kevin_daniels, censor).
actor(the_island, grant_garrison, censor).
actor(the_island, kenneth_hughes, censor).
actor(the_island, brian_leckner, censor).
actor(the_island, dakota_mitchell, censor).
actor(the_island, marty_papazian, censor).
actor(the_island, phil_somerville, censor).
actor(the_island, ryan_tasz, censor).
actor(the_island, kirk_ward, censor).
actor(the_island, kelvin_han_yee, censor).
actress(the_island, shawnee_smith, suzie).
actor(the_island, chris_ellis, aces__spades_bartender).
actor(the_island, don_michael_paul, bar_guy).
actor(the_island, eric_stonestreet, ed_the_trucker).
actor(the_island, james_granoff, sarah_s_son).
actor(the_island, james_hart, lapd_officer).
actor(the_island, craig_reynolds, lapd_officer).
actor(the_island, trent_ford, calvin_klein_model).
actress(the_island, sage_thomas, girl_at_beach).
actor(the_island, mark_christopher_lawrence, construction_worker).
actress(the_island, jenae_altschwager, kim).
actor(the_island, john_anton, clone).
actress(the_island, mary_castro, busty_dancer_in_bar).
actor(the_island, kim_coates, charles_whitman).
actor(the_island, tom_everett, the_president).
actor(the_island, mitch_haubert, censor_doctor).
actor(the_island, robert_isaac, agnate).
actor(the_island, j_p_manoux, seven_foxtrot).
actress(the_island, jennifer_secord, patron).
actor(the_island, mckay_stewart, falling_building_dodger).
actor(the_island, skyler_stone, sarah_jordan_s_husband).
actor(the_island, richard_john_walters, agnate).

movie(a_love_song_for_bobby_long, 2004).
director(a_love_song_for_bobby_long, shainee_gabel).
actor(a_love_song_for_bobby_long, john_travolta, bobby_long).
actress(a_love_song_for_bobby_long, scarlett_johansson, pursy_will).
actor(a_love_song_for_bobby_long, gabriel_macht, lawson_pines).
actress(a_love_song_for_bobby_long, deborah_kara_unger, georgianna).
actor(a_love_song_for_bobby_long, dane_rhodes, cecil).
actor(a_love_song_for_bobby_long, david_jensen, junior).
actor(a_love_song_for_bobby_long, clayne_crawford, lee).
actor(a_love_song_for_bobby_long, sonny_shroyer, earl).
actor(a_love_song_for_bobby_long, walter_breaux, ray).
actress(a_love_song_for_bobby_long, carol_sutton, ruthie).
actor(a_love_song_for_bobby_long, warren_kole, sean).
actor(a_love_song_for_bobby_long, bernard_johnson, tiny).
actress(a_love_song_for_bobby_long, gina_ginger_bernal, waitress).
actor(a_love_song_for_bobby_long, douglas_m_griffin, man_1).
actor(a_love_song_for_bobby_long, earl_maddox, man_2).
actor(a_love_song_for_bobby_long, steve_maye, man_3).
actor(a_love_song_for_bobby_long, don_brady, old_man).
actor(a_love_song_for_bobby_long, will_barnett, old_man_2).
actor(a_love_song_for_bobby_long, patrick_mccullough, streetcar_boy).
actress(a_love_song_for_bobby_long, leanne_cochran, streetcar_girl).
actor(a_love_song_for_bobby_long, nick_loren, merchant).
actress(a_love_song_for_bobby_long, brooke_allen, sandy).
actor(a_love_song_for_bobby_long, sal_sapienza, jazz_club_patron).
actor(a_love_song_for_bobby_long, doc_whitney, alcoholic).

movie(manny__lo, 1996).
director(manny__lo, lisa_krueger).
actress(manny__lo, mary_kay_place, elaine).
actress(manny__lo, scarlett_johansson, amanda).
actress(manny__lo, aleksa_palladino, laurel).
actor(manny__lo, dean_silvers, suburban_family).
actress(manny__lo, marlen_hecht, suburban_family).
actor(manny__lo, forrest_silvers, suburban_family).
actor(manny__lo, tyler_silvers, suburban_family).
actress(manny__lo, lisa_campion, convenience_store_clerk).
actor(manny__lo, glenn_fitzgerald, joey).
actress(manny__lo, novella_nelson, georgine).
actress(manny__lo, susan_decker, baby_store_customer_1).
actress(manny__lo, marla_zuk, baby_store_customer_2).
actress(manny__lo, bonnie_johnson, baby_store_customer_3).
actress(manny__lo, melissa_johnson, child).
actress(manny__lo, angie_phillips, connie).
actor(manny__lo, cameron_boyd, chuck).
actress(manny__lo, monica_smith, chuck_s_mom).
actress(manny__lo, melanie_johansson, golf_course_family).
actor(manny__lo, karsten_johansson, golf_course_family).
actor(manny__lo, hunter_johansson, golf_course_family).
actress(manny__lo, vanessa_johansson, golf_course_family).
actor(manny__lo, frank_green_jr, other_golfer).
actress(manny__lo, shelley_dee_green, other_golfer).
actor(manny__lo, david_destaebler, golf_course_cop).
actor(manny__lo, mark_palmieri, golf_course_cop).
actor(manny__lo, paul_guilfoyle, country_house_owner).
actor(manny__lo, tony_arnaud, sheriff).
actor(manny__lo, nicholas_lent, lo_s_baby).

movie(match_point, 2005).
director(match_point, woody_allen).
actress(match_point, scarlett_johansson, nola_rice).
actor(match_point, jonathan_rhys_meyers, chris_wilton).
actress(match_point, emily_mortimer, chloe_hewett_wilton).
actor(match_point, matthew_goode, tom_hewett).
actor(match_point, brian_cox, alec_hewett).
actress(match_point, penelope_wilton, eleanor_hewett).
actor(match_point, layke_anderson, youth_at_palace_theatre).
actor(match_point, alexander_armstrong, '').
actor(match_point, morne_botes, michael).
actress(match_point, rose_keegan, carol).
actor(match_point, eddie_marsan, reeves).
actor(match_point, james_nesbitt, '').
actor(match_point, steve_pemberton, di_parry).
actress(match_point, miranda_raison, heather).
actor(match_point, colin_salmon, '').
actress(match_point, zoe_telford, samantha).

movie(my_brother_the_pig, 1999).
director(my_brother_the_pig, erik_fleming).
actor(my_brother_the_pig, nick_fuoco, george_caldwell).
actress(my_brother_the_pig, scarlett_johansson, kathy_caldwell).
actor(my_brother_the_pig, judge_reinhold, richard_caldwell).
actress(my_brother_the_pig, romy_windsor, dee_dee_caldwell).
actress(my_brother_the_pig, eva_mendes, matilda).
actor(my_brother_the_pig, alex_d_linz, freud).
actor(my_brother_the_pig, paul_renteria, border_guard).
actress(my_brother_the_pig, renee_victor, grandma_berta).
actress(my_brother_the_pig, cambria_gonzalez, mercedes).
actress(my_brother_the_pig, nicole_zarate, annie).
actor(my_brother_the_pig, eduardo_antonio_garcia, luis).
actress(my_brother_the_pig, siri_baruc, tourist_girl).
actor(my_brother_the_pig, charlie_combes, tourist_dad).
actress(my_brother_the_pig, dee_ann_johnston, tourist_mom).
actor(my_brother_the_pig, marco_rodriguez, eduardo).
actor(my_brother_the_pig, rob_johnston, taxi_driver).
actor(my_brother_the_pig, dee_bradley_baker, pig_george).

movie(north, 1994).
director(north, rob_reiner).
actor(north, elijah_wood, north).
actor(north, jason_alexander, north_s_dad).
actress(north, julia_louis_dreyfus, north_s_mom).
actor(north, marc_shaiman, piano_player).
actor(north, jussie_smollett, adam).
actress(north, taylor_fry, zoe).
actress(north, alana_austin, sarah).
actress(north, peg_shirley, teacher).
actor(north, chuck_cooper, umpire).
actor(north, alan_zweibel, coach).
actor(north, donavon_dietz, assistant_coach).
actor(north, teddy_bergman, teammate).
actor(north, michael_cipriani, teammate).
actor(north, joran_corneal, teammate).
actor(north, joshua_kaplan, teammate).
actor(north, bruce_willis, narrator).
actor(north, james_f_dean, dad_smith).
actor(north, glenn_walker_harris_jr, jeffrey_smith).
actress(north, nancy_nichols, mom_jones).
actor(north, ryan_o_neill, andy_wilson).
actor(north, kim_delgado, dad_johnson).
actor(north, tony_t_johnson, steve_johnson).
actor(north, matthew_mccurley, winchell).
actress(north, carmela_rappazzo, receptionist).
actor(north, jordan_jacobson, vice_president).
actress(north, rafale_yermazyan, austrian_dancer).
actor(north, jon_lovitz, arthur_belt).
actor(north, mitchell_group, dad_wilson).
actress(north, pamela_harley, reporter).
actor(north, glenn_kubota, reporter).
actor(north, matthew_arkin, reporter).
actor(north, marc_coppola, reporter).
actress(north, colette_bryce, reporter).
actor(north, bryon_stewart, bailiff).
actor(north, alan_arkin, judge_buckle).
actor(north, alan_rachins, defense_attorney).
actress(north, abbe_levin, operator).
actress(north, lola_pashalinski, operator).
actress(north, kimberly_topper, operator).
actress(north, c_c_loveheart, operator).
actress(north, helen_hanft, operator).
actress(north, carol_honda, operator).
actress(north, peggy_gormley, operator).
actress(north, lillias_white, operator).
actor(north, dan_aykroyd, pa_tex).
actress(north, reba_mcentire, ma_tex).
actor(north, mark_meismer, texas_dancer).
actress(north, danielle_burgio, texas_dancer).
actor(north, bryan_anthony, texas_dancer).
actress(north, carmit_bachar, texas_dancer).
actor(north, james_harkness, texas_dancer).
actress(north, krista_buonauro, texas_dancer).
actor(north, brett_heine, texas_dancer).
actress(north, kelly_cooper, texas_dancer).
actor(north, chad_e_allen, texas_dancer).
actress(north, stefanie_roos, texas_dancer).
actor(north, donovan_keith_hesser, texas_dancer).
actress(north, jenifer_strovas, texas_dancer).
actor(north, christopher_d_childers, texas_dancer).
actor(north, sebastian_lacause, texas_dancer).
actress(north, lydia_e_merritt, texas_dancer).
actor(north, greg_rosatti, texas_dancer).
actress(north, kelly_shenefiel, texas_dancer).
actress(north, jenifer_panton, betty_lou).
actor(north, keone_young, governor_ho).
actress(north, lauren_tom, mrs_ho).
actor(north, gil_janklowicz, man_on_beach).
actress(north, maud_winchester, stewart_s_mom).
actor(north, tyler_gurciullo, stewart).
actor(north, fritz_sperberg, stewart_s_dad).
actress(north, brynn_hartman, waitress).
actor(north, larry_b_williams, alaskan_pilot).
actor(north, graham_greene, alaskan_dad).
actress(north, kathy_bates, alaskan_mom).
actor(north, abe_vigoda, alaskan_grandpa).
actor(north, richard_belzer, barker).
actor(north, monty_bass, eskimo).
actor(north, farrell_thomas, eskimo).
actor(north, billy_daydoge, eskimo).
actor(north, henri_towers, eskimo).
actress(north, caroline_carr, eskimo).
actress(north, eva_larson, eskimo).
actor(north, ben_stein, curator).
actress(north, marla_frees, d_c_reporter).
actor(north, robert_rigamonti, d_c_reporter).
actor(north, alexander_godunov, amish_dad).
actress(north, kelly_mcgillis, amish_mom).
actor(north, jay_black, amish_pilot).
actress(north, rosalind_chao, chinese_mom).
actor(north, george_cheung, chinese_barber).
actor(north, ayo_adejugbe, african_dad).
actress(north, darwyn_carson, african_mom).
actress(north, lucy_lin, female_newscaster).
actress(north, faith_ford, donna_nelson).
actor(north, john_ritter, ward_nelson).
actress(north, scarlett_johansson, laura_nelson).
actor(north, jesse_zeigler, bud_nelson).
actor(north, robert_costanzo, al).
actress(north, audrey_klebahn, secretary).
actor(north, philip_levy, panhandler).
actor(north, dan_grimaldi, hot_dog_vendor).
actor(north, marvin_braverman, waiter).
actress(north, wendle_josepher, ticket_agent).
actor(north, adam_zweibel, kid_in_airport).
actor(north, matthew_horn, kid_in_airport).
actress(north, sarah_martineck, kid_in_airport).
actor(north, brian_levinson, kid_in_airport).
actor(north, d_l_shroder, federal_express_agent).
actor(north, brother_douglas, new_york_city_pimp).
actor(north, nick_taylor, newsman).
actor(north, jim_great_elk_waters, eskimo_father).
actor(north, michael_werckle, amish_boy).

movie(the_perfect_score, 2004).
director(the_perfect_score, brian_robbins).
actress(the_perfect_score, erika_christensen, anna_ross).
actor(the_perfect_score, chris_evans, kyle).
actor(the_perfect_score, bryan_greenberg, matty_matthews).
actress(the_perfect_score, scarlett_johansson, francesca_curtis).
actor(the_perfect_score, darius_miles, desmond_rhodes).
actor(the_perfect_score, leonardo_nam, roy).
actress(the_perfect_score, tyra_ferrell, desmond_s_mother).
actor(the_perfect_score, matthew_lillard, larry).
actress(the_perfect_score, vanessa_angel, anita_donlee).
actor(the_perfect_score, bill_mackenzie, lobby_guard).
actor(the_perfect_score, dan_zukovic, mr_g).
actress(the_perfect_score, iris_quinn, kyle_s_mother).
actress(the_perfect_score, lorena_gale, proctor).
actress(the_perfect_score, patricia_idlette, receptionist).
actress(the_perfect_score, lynda_boyd, anna_s_mother).
actor(the_perfect_score, michael_ryan, anna_s_father).
actor(the_perfect_score, robert_clarke, arnie_branch).
actor(the_perfect_score, serge_houde, kurt_dooling).
actor(the_perfect_score, kyle_labine, dave).
actor(the_perfect_score, dee_jay_jackson, ets_lobby_guard).
actor(the_perfect_score, alf_humphreys, tom_helton).
actor(the_perfect_score, fulvio_cecere, francesca_s_father).
actor(the_perfect_score, mike_jarvis, illinois_coach).
actor(the_perfect_score, steve_makaj, kyle_s_father).
actor(the_perfect_score, kurt_max_runte, swat_captain).
actor(the_perfect_score, jay_brazeau, test_instructor).
actress(the_perfect_score, rebecca_reichert, tiffany).
actress(the_perfect_score, jessica_may, ets_woman).
actress(the_perfect_score, miriam_smith, ets_reception).
actor(the_perfect_score, alex_green, security_guard).
actor(the_perfect_score, samuel_scantlebury, keyon).
actress(the_perfect_score, sonja_bennett, pregnant_girl).
actress(the_perfect_score, sarah_afful, girl).
actor(the_perfect_score, alex_corr, preppy_boy).
actor(the_perfect_score, nikolas_malenovic, boy).
actor(the_perfect_score, john_shaw, ets_man).
actor(the_perfect_score, jamie_yochlowitz, man_in_jail).
actor(the_perfect_score, rob_boyce, guard).
actor(the_perfect_score, paul_campbell, guy_in_truck).

movie(the_spongebob_squarepants_movie, 2004).
director(the_spongebob_squarepants_movie, stephen_hillenburg).
actor(the_spongebob_squarepants_movie, tom_kenny, spongebob_narrator_gary_clay_tough_fish_2_twin_2_houston_voice).
actor(the_spongebob_squarepants_movie, clancy_brown, mr_krabs).
actor(the_spongebob_squarepants_movie, rodger_bumpass, squidward_fish_4).
actor(the_spongebob_squarepants_movie, bill_fagerbakke, patrick_star_fish_2_chum_customer_local_fish).
actor(the_spongebob_squarepants_movie, mr_lawrence, plankton_fish_7_attendant_2_lloyd).
actress(the_spongebob_squarepants_movie, jill_talley, karen_the_computer_wife_old_lady).
actress(the_spongebob_squarepants_movie, carolyn_lawrence, sandy).
actress(the_spongebob_squarepants_movie, mary_jo_catlett, mrs_puff).
actor(the_spongebob_squarepants_movie, jeffrey_tambor, king_neptune).
actress(the_spongebob_squarepants_movie, scarlett_johansson, mindy).
actor(the_spongebob_squarepants_movie, alec_baldwin, dennis).
actor(the_spongebob_squarepants_movie, david_hasselhoff, himself).
actor(the_spongebob_squarepants_movie, kristopher_logan, squinty_the_pirate).
actor(the_spongebob_squarepants_movie, d_p_fitzgerald, bonesy_the_pirate).
actor(the_spongebob_squarepants_movie, cole_s_mckay, scruffy_the_pirate).
actor(the_spongebob_squarepants_movie, dylan_haggerty, stitches_the_pirate).
actor(the_spongebob_squarepants_movie, bart_mccarthy, captain_bart_the_pirate).
actor(the_spongebob_squarepants_movie, henry_kingi, inky_the_pirate).
actor(the_spongebob_squarepants_movie, randolph_jones, tiny_the_pirate).
actor(the_spongebob_squarepants_movie, paul_zies, upper_deck_the_pirate).
actor(the_spongebob_squarepants_movie, gerard_griesbaum, fingers_the_pirate).
actor(the_spongebob_squarepants_movie, aaron_hendry, tangles_the_pirate_cyclops_diver).
actor(the_spongebob_squarepants_movie, maxie_j_santillan_jr, gummy_the_pirate).
actor(the_spongebob_squarepants_movie, peter_deyoung, leatherbeard_the_pirate).
actor(the_spongebob_squarepants_movie, gino_montesinos, tango_the_pirate).
actor(the_spongebob_squarepants_movie, john_siciliano, pokey_the_pirate).
actor(the_spongebob_squarepants_movie, david_stifel, cookie_the_pirate).
actor(the_spongebob_squarepants_movie, alex_baker, martin_the_pirate).
actor(the_spongebob_squarepants_movie, robin_russell, sniffy_the_pirate).
actor(the_spongebob_squarepants_movie, tommy_schooler, salty_the_pirate).
actor(the_spongebob_squarepants_movie, ben_wilson, stovepipe_the_pirate).
actor(the_spongebob_squarepants_movie, jose_zelaya, dooby_the_pirate).
actress(the_spongebob_squarepants_movie, mageina_tovah, usher).
actor(the_spongebob_squarepants_movie, chris_cummins, concession_guy).
actor(the_spongebob_squarepants_movie, todd_duffey, concession_guy).
actor(the_spongebob_squarepants_movie, dee_bradley_baker, man_cop_phil_perch_perkins_waiter_attendant_1_thug_1_coughing_fish_twin_1_frog_fish_monster_freed_fish_sandals).
actress(the_spongebob_squarepants_movie, sirena_irwin, reporter_driver_ice_cream_lady).
actress(the_spongebob_squarepants_movie, lori_alan, pearl).
actor(the_spongebob_squarepants_movie, thomas_f_wilson, fish_3_tough_fish_1_victor).
actor(the_spongebob_squarepants_movie, carlos_alazraqui, squire_goofy_goober_announcer_thief).
actor(the_spongebob_squarepants_movie, joshua_seth, prisoner).
actor(the_spongebob_squarepants_movie, tim_blaney, singing_goofy_goober).
actor(the_spongebob_squarepants_movie, derek_drymon, the_screamer_fisherman).
actor(the_spongebob_squarepants_movie, aaron_springer, laughing_bubble).
actor(the_spongebob_squarepants_movie, neil_ross, cyclops).
actor(the_spongebob_squarepants_movie, stephen_hillenburg, parrot).
actor(the_spongebob_squarepants_movie, michael_patrick_bell, fisherman).
actor(the_spongebob_squarepants_movie, jim_wise, goofy_goober_rock_singer).

movie(untitled_woody_allen_fall_project_2006, 2006).
director(untitled_woody_allen_fall_project_2006, woody_allen).
actor(untitled_woody_allen_fall_project_2006, woody_allen, '').
actor(untitled_woody_allen_fall_project_2006, jody_halse, bouncer).
actor(untitled_woody_allen_fall_project_2006, hugh_jackman, '').
actress(untitled_woody_allen_fall_project_2006, scarlett_johansson, '').
actor(untitled_woody_allen_fall_project_2006, robyn_kerr, '').
actor(untitled_woody_allen_fall_project_2006, kevin_mcnally, mike_tinsley).
actor(untitled_woody_allen_fall_project_2006, ian_mcshane, '').
actor(untitled_woody_allen_fall_project_2006, james_nesbitt, '').
actor(untitled_woody_allen_fall_project_2006, colin_salmon, '').

movie(a_view_from_the_bridge, 2006).
actress(a_view_from_the_bridge, scarlett_johansson, catherine).
actor(a_view_from_the_bridge, anthony_lapaglia, eddie_carbone).

