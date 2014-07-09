
[1mFrom:[0m /vagrant/senior_projects/walking_with_the_dead/lib/wwtd/commands/enter_living_room.rb @ line 16 WWTD::EnterLivingRoom#run:

     [1;34m6[0m: [32mdef[0m [1;34mrun[0m(player, room)
     [1;34m7[0m:   qp_data = get_quest_data(player.id, room.quest_id)
     [1;34m8[0m:   entered_before = qp_data[[31m[1;31m"[0m[31mentered_living_room[1;31m"[0m[31m[0m]
     [1;34m9[0m:   zombie_dead = qp_data[[31m[1;31m'[0m[31mkilled_first_zombie[1;31m'[0m[31m[0m]
    [1;34m10[0m:   [32mif[0m entered_before && zombie_dead
    [1;34m11[0m:     [32mreturn[0m success [33m:message[0m => room.description, [33m:player[0m => player
    [1;34m12[0m:   [32mend[0m
    [1;34m13[0m: 
    [1;34m14[0m:   [1;34;4mWWTD[0m.db.change_qp_data(player.id, [1;34m1[0m, [35mentered_living_room[0m: [1;36mtrue[0m)
    [1;34m15[0m:   first_action = qp_data[[31m[1;31m"[0m[31mfirst_completed_action[1;31m"[0m[31m[0m]
 => [1;34m16[0m:   binding.pry
    [1;34m17[0m:   [32mif[0m first_action == [31m[1;31m'[0m[31muse phone[1;31m'[0m[31m[0m
    [1;34m18[0m:     attacking_zombie = [1;34;4mAsciiArt[0m.new([31m[1;31m"[0m[31m./lib/assets/attacking_zombie.jpg[1;31m"[0m[31m[0m)
    [1;34m19[0m:     puts attacking_zombie.to_ascii_art
    [1;34m20[0m:     puts [31m[1;31m"[0m[31mOH NO! You thought the cure worked.[1;31m"[0m[31m[0m.white.on_red
    [1;34m21[0m:     puts [31m[1;31m"[0m[31mBut nope. It didn't, and zombies are back. Unfortunately, one just crashed through the window and attacked, killing you.[1;31m"[0m[31m[0m.white.on_red
    [1;34m22[0m:     puts [31m[1;31m"[0m[31mMaybe you should have answered that phone call...[1;31m"[0m[31m[0m.white.on_red
    [1;34m23[0m:     new_player = [1;34;4mWWTD[0m.db.update_player(player.id, [35mdead[0m: [1;36mtrue[0m)
    [1;34m24[0m:     [32mreturn[0m success [33m:message[0m => [31m[1;31m"[0m[31mGAME OVER[1;31m"[0m[31m[0m, [33m:player[0m => new_player
    [1;34m25[0m:   [32melse[0m
    [1;34m26[0m:     attacking_zombie = [1;34;4mAsciiArt[0m.new([31m[1;31m"[0m[31m./lib/assets/attacking_zombie.jpg[1;31m"[0m[31m[0m)
    [1;34m27[0m:     puts attacking_zombie.to_ascii_art
    [1;34m28[0m:     zombie = [1;34;4mWWTD[0m.db.get_character_by_name([31m[1;31m"[0m[31mFirst Zombie[1;31m"[0m[31m[0m)
    [1;34m29[0m:     [32mreturn[0m success [33m:message[0m => zombie.description, [33m:player[0m => player
    [1;34m30[0m:   [32mend[0m
    [1;34m31[0m: [32mend[0m

