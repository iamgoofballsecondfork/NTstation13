/obj/machinery/cooking
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	var/candy = 0
	idle_power_usage = 5
	var/on = FALSE	//Is it making food already?
	var/list/food_choices = list()

/obj/machinery/cooking/New()
	..()
	updatefood()

/obj/machinery/cooking/attackby(obj/item/I, mob/user)
	if(on)
		user << "The machine is already running."
		return
	if(!istype(I,/obj/item/weapon/reagent_containers/food/snacks/))
		user << "That isn't food."
		return
	else
		on = TRUE
		var/obj/item/weapon/reagent_containers/food/snacks/F = I
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/C
		var/batchsize
		C = input("Select food to make.", "Cooking", C) in food_choices
		batchsize = input("How many do you wish to make?", name, batchsize) as num
		batchsize = Clamp(round(batchsize),1,12)
		if(!C)
			return
		if(!batchsize)
			return
		else
			user << "You put [F] into [src] for cooking."
			user.drop_item()
			F.loc = src
			if(!candy)
				icon_state = "oven_on"
			else
				icon_state = "mixer_on"
			sleep(50*batchsize)
			on = FALSE
			if(!candy)
				icon_state = "oven_off"
			else
				icon_state = "mixer_off"

/* This doesn't do anything fix your shit goofball.- Remie
			for(var/i = 0, i < batchsize, i++)
				var/obj/item/weapon/reagent_containers/food/snacks/customizable/B = C
				B.loc
*/
			C.loc = get_turf(src)
			C.attackby(F,user)
			playsound(loc, 'sound/machines/ding.ogg', 50, 1)
			updatefood()
			return

/obj/machinery/cooking/proc/updatefood()
	return

/obj/machinery/cooking/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "oven_off"

/obj/machinery/cooking/oven/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/cook))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/cook/V = new U
		src.food_choices += V
	return

/obj/machinery/cooking/candy
	name = "candy machine"
	desc = "Get yer box of deep fried deep fried deep fried deep fried cotton candy cereal sandwich cookies here!"
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "mixer_off"
	candy = 1

/obj/machinery/cooking/candy/updatefood()
	for(var/U in food_choices)
		food_choices.Remove(U)
	for(var/U in typesof(/obj/item/weapon/reagent_containers/food/snacks/customizable/candy)-(/obj/item/weapon/reagent_containers/food/snacks/customizable/candy))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/candy/V = new U
		src.food_choices += V
	return
