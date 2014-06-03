/obj/machinery/bathtub
	name = "bathtub"
	desc = "Scrub-a-dub-dub." // sorry
	icon = 'icons/obj/bathtub.dmi'
	icon_state = "bathtub_empty"
	flags = OPENCONTAINER
	anchored = 1
	var/max_reagent_storage = 1000
	var/starting_reagent = "water"
	var/empty = 0

/obj/machinery/bathtub/empty
	empty = 1

/obj/machinery/bathtub/big
	name = "big bathtub"
	desc = "For when you really need to scrub-a-dub-dub."
	icon = 'icons/obj/bathtub_b.dmi' // Due to how BYOND Handles DMIs and the sizes of the icons inside of them I needed to have separate DMIs for them.
	max_reagent_storage = 5000

/obj/machinery/bathtub/big/empty
	empty = 1

/obj/machinery/bathtub/New()
	create_reagents(max_reagent_storage)
	if(!empty)
		reagents.add_reagent(starting_reagent, max_reagent_storage)

/obj/machinery/bathtub/on_reagent_change()
	if(reagents)
		if(reagents.total_volume)
			icon_state = "bathtub"
		else
			icon_state = "bathtub_empty"
/obj/machinery/bathtub/examine()
	// From what I can tell, mob/user as mob doesn't work with examine.
	set src in view()
	..()
	if(!(usr in view(2)) && usr != loc)
		return
	if(reagents && reagents.reagent_list.len)
		usr << "You think it contains:"
		for(var/datum/reagent/R in reagents.reagent_list)
			var/randomvalue
			var/randommethod = pick("plus", "minus")
			switch(randommethod)
				if("plus")
					randomvalue = R.volume + rand(1,30)
				if("minus")
					randomvalue = R.volume - rand(1,30)
			if(randomvalue >= max_reagent_storage)
				randomvalue = max_reagent_storage
				randomvalue--
			if(randomvalue <= 0)
				randomvalue = 0
				randomvalue++
			usr << "[randomvalue] units of [R.name]"