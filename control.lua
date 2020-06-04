function trigger()

    -- loop all forces
    for _, force in pairs(game.forces) do

        -- loop networks of a force (grouped by surface)
        for _, logistic_networks in pairs(force.logistic_networks) do

            -- loop the networks for the current surface ^
            for _, logistic_network in pairs(logistic_networks) do

                -- loop the list that can contain buffer chests
                for _, logistic_chest in pairs(logistic_network.requester_points) do

                    -- check if the requesting chest is a green buffer chest
                    if(logistic_chest.mode == defines.logistic_mode.buffer) then

                        -- loop all items in its inventory
                        local inventory = logistic_chest.owner.get_inventory(defines.inventory.chest)
                        for item, amount in pairs(inventory.get_contents()) do

                            -- without a filter the item should be thrown out
                            local max = 0

                            -- loop all the filters and set the max to it if it matches
                            if (logistic_chest.filters) then
                                for _, filter in pairs(logistic_chest.filters) do
                                    if (filter.name == item) then
                                        max = filter.count
                                    end
                                end
                            end

                            -- throw the overstock onto the ground + mark for deconstruction
                            if(amount > max) then
                                logistic_chest.owner.surface.spill_item_stack(logistic_chest.owner.position, {name = item, count = amount - max}, false, logistic_chest.owner.force, false)
                                inventory.remove({name = item, count = amount - max})
                            end

                        end
                    end
                end
            end

        end
    end
end

script.on_nth_tick(60 * 1, trigger)
