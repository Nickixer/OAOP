using HorizonSideRobots

function move_and_count(r::Robot, side::HorizonSide)
    steps = 0
    while !isborder(r, side)
        move!(r, side)
        steps += 1
    end
    return steps
end

function move_back(r::Robot, side::HorizonSide, steps::Int)
    for _ in 1:steps
        move!(r, side)
    end
end

function mark_chessboard(r::Robot)
    # Размер поля
    steps_north = move_and_count(r, Nord)
    steps_south = move_and_count(r, Sud)
    steps_west = move_and_count(r, West)
    steps_east = move_and_count(r, Ost)

    # Обратно в исходную
    move_back(r, Nord, steps_north)
    move_back(r, Sud, steps_south)
    move_back(r, West, steps_west)
    move_back(r, Ost, steps_east)

    # размеры поля
    rows = steps_north + steps_south + 1
    cols = steps_west + steps_east + 1

    # идти в верхний левый угол
    for _ in 1:steps_north
        move!(r, Nord)
    end
    for _ in 1:steps_west
        move!(r, West)
    end

    # шахматное поле
    is_white = true
    for row in 1:rows
        for col in 1:cols
            if is_white
                putmarker!(r)
            end
            if !isborder(r, Ost)
                move!(r, Ost)
                is_white = !is_white
            end
        end
        # Возврат в анчало строки
        for _ in 1:cols-1
            move!(r, West)
        end
        # Переход на след строку
        if row < rows
            move!(r, Sud)
            is_white = !is_white
        end
    end

    # Возврат в начало
    for _ in 1:steps_north
        move!(r, Nord)
    end
    for _ in 1:steps_west
        move!(r, West)
    end
end

r = Robot(animate=true)
mark_chessboard(r)
