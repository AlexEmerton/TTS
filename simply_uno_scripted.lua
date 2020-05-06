UNO_DECK_GUID = 'aa2acc'
DECK_ZONE_GUID = '0d796b'
NUMBER_OF_GAMES_PLAYED = 0

-- todo improvements
--
-- 1. Game is broken if the deck runs out
-- > Find a way to make a discard deck a new uno_deck if uno_deck is nil
--
-- 2. Decide a winner
-- > Check player hands on every onObjectEnterScriptingZone, if there are no
-- > more objects in any player hand call, announce the winner

function onload()
    -- Greet players
    printWelcomeMessage()
    printPlayerGreetings()

    -- Create the game start button
    createStartButton()
    createRestartButton()
    createDrawTwoButton()
    createDrawFourButton()
end

function wait(seconds)
  local start = os.time()
  repeat until os.time() > start + seconds
end

-- function onObjectEnterScriptingZone(zone, enter_obj)
--     print(zone.tag)
--     if enter_obj.tag == 'Card' then
--         if not enter_obj.is_face_down then
--             print("Dropped a card!")
--         end
--     end
-- end

function createDrawTwoButton()
    draw_two_button = spawnObject({
        type = 'FogOfWar',
        position = {-5, -1, 6},
        scale = {1, 1, 1}
    })

    draw_two_button.createButton({
        click_function = 'drawTwo',
        function_owner = nil,
        label = 'Поднять 2',
        position = {0, 0, 0, 0},
        rotation = {0, 180, 0},
        width = 2400,
        height = 1000,
        font_size = 500,
        tooltip = 'Поднять две карты'
    })
end

function createDrawFourButton()
    draw_four_button = spawnObject({
        type = 'FogOfWar',
        position = {-5, -1, 4},
        scale = {1, 1, 1}
    })

    draw_four_button.createButton({
        click_function = 'drawFour',
        function_owner = nil,
        label = 'Поднять 4',
        position = {0, 0, 0, 0},
        rotation = {0, 180, 0},
        width = 2400,
        height = 1000,
        font_size = 500,
        tooltip = 'Поднять четыре карты'
    })
end

function createStartButton()
    start_button = spawnObject({
        type = 'FogOfWar',
        position = {0, 1, 6},
        scale = {1, 1, 1}
    })

    start_button.createButton({
        click_function = 'startGame',
        color = {r=0, g=1, b=1},
        font_color = {r=1, g=1, b=1},
        function_owner = nil,
        label = 'Лэтс го!',
        position = {0, 0, 0, 0},
        rotation = {0, 180, 0},
        width = 2000,
        height = 1000,
        font_size = 500,
        tooltip = 'Начать игру'
    })
end

function createRestartButton()
    restart_button = spawnObject({
        type = 'FogOfWar',
        position = {0, -1, 6},
        scale = {1, 1, 1}
    })

    restart_button.createButton({
        click_function = 'restartGame',
        color = {r=0, g=1, b=1},
        font_color = {r=1, g=1, b=1},
        function_owner = nil,
        label = 'Ещё одну!',
        position = {0, 0, 0, 0},
        rotation = {0, 180, 0},
        width = 2000,
        height = 1000,
        font_size = 400,
        tooltip = 'Рестарт игру'
    })
end

function drawTwo(owner, click_color)
    uno_deck.deal(2, click_color)
    broadcastToAll(Player[click_color].steam_name .. " поднял 2 карты.")
end

function drawFour(owner, click_color)
    uno_deck.deal(4, click_color)
    broadcastToAll(Player[click_color].steam_name .. " поднял 4 карты.")
end

function moveDeckAway(deck)
    deck.setPositionSmooth({10, 2, 0, 0})
end

function getAllCurrentCardsInHand()
    cards_in_hands = {}
    players = Player.getPlayers()

    for player_ind, player_val in pairs(players) do
        objectsInHand = player_val.getHandObjects()

        for obj_ind, obj_val in pairs(objectsInHand) do
            table.insert(cards_in_hands, obj_val)
        end
    end
    return cards_in_hands
end

function collectAllPlayedCards(deck, zone)
    objects_in_play = zone.getObjects()

    if next(objects_in_play) == nil then
        -- Exit early if there's nothing in play
        return
    else
        for i, object in pairs(objects_in_play) do
            if (object.tag == 'Card') or (object.tag == 'Deck' and object.guid != 'aa2acc') then
                deck.putObject(object)
            end
        end
    end
end

function collectAllCardsInHands(deck)
    cards_in_hands = getAllCurrentCardsInHand()

    if next(cards_in_hands) == nil then
        -- Exit early if there's nothing in hands
        return
    else
        for i, card in pairs(cards_in_hands) do
            deck.putObject(card)
        end
    end
end

function restartGame()
    -- Clear the chat
    for i=1, 5 do
        print()
    end

    NUMBER_OF_GAMES_PLAYED = NUMBER_OF_GAMES_PLAYED + 1
    print("Начинаем игру номер " .. NUMBER_OF_GAMES_PLAYED)

    printGameStartMessage()

    -- Clean up the cards
    collectAllPlayedCards(uno_deck, deck_zone)
    collectAllCardsInHands(uno_deck)

    -- Delays are required to stop the cards stacking on top of the deck
    -- very weird bug behaviour, funny though!
    Wait.time(function() uno_deck.shuffle() end, 1)
    Wait.time(function() uno_deck.deal(7) end, 1)
end

function startGame()
    -- Shuffle the buttons around
    start_button.setPosition({0, 100, 6, 0})
    restart_button.setPosition({0, 1, 6, 0})
    draw_two_button.setPosition({-5, 1, 6})
    draw_four_button.setPosition({-5, 1, 4})

    uno_deck = getObjectFromGUID(UNO_DECK_GUID)
    deck_zone = getObjectFromGUID(DECK_ZONE_GUID)

    printGameStartMessage()
    uno_deck.deal(7)
end

function printWelcomeMessage()
    print("Добро пожаловать в Уно!")
end

function printGameStartMessage()
    random_game_start_msg = {
        [1] = [["На войне нет приза за второе место."
        — Генерал Омар Брэдли ]],
        [2] = [["Никогда не перебивайте своего врага, когда он совершает ошибку."
        — Наполеон Бонапарт ]],
        [3] = [["Око за око делает весь мир слепым".
        - Ганди]],
        [4] = [["Если вы знаете врага и знаете себя, вам не нужно бояться результатов сотен сражений"
        — Сунь Цзы ]],
        [5] = [["Прежде чем отправиться в путь мести, тебе нужно сначала выкопать две могилы".
        - Конфуций ]],
        [6] = [["Один хороший акт мести заслуживает другого"
        - Джон Джефферсон]]
    }

    greeting_random_ind = math.random(1, 5)
    broadcastToAll(random_game_start_msg[greeting_random_ind], {r=1, g=1, b=0})
end

function printPlayerGreetings()
    random_greetings = {
        [1] = "Рады тебя видеть ",
        [2] = "Знаменитость! Какая честь, что ты здесь ",
        [3] = "О нет, это ",
        [4] = "Их Императорское Высочество здесь, все приветствуют ",
        [5] = "Не ожидали увидеть тебя здесь, привет ",
    }
    players = Player.getPlayers()
    greeting_random_ind = math.random(1, 5)

    for player_ind, player_val in pairs(players) do
        broadcastToAll(random_greetings[greeting_random_ind] .. player_val.steam_name .. "!",  {r=0, g=1, b=0.5})
    end
end
