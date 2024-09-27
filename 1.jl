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

function find_center(r::Robot)
    # шаги до границы
    steps_north = move_and_count(r, Nord)
    steps_south = move_and_count(r, Sud)
    steps_west = move_and_count(r, West)
    steps_east = move_and_count(r, Ost)

    # Исходная позиция
    move_back(r, Nord, steps_north)
    move_back(r, Sud, steps_south)
    move_back(r, West, steps_west)
    move_back(r, Ost, steps_east)

    # размер поля
    rows = steps_north + steps_south + 1
    cols = steps_west + steps_east + 1

    # центр поля
    center_row = (rows + 1) ÷ 2
    center_col = (cols + 1) ÷ 2

    # Перемещение в центр
    for _ in 1:steps_north - (center_row - 1)
        move!(r, Nord)
    end
    for _ in 1:steps_west - (center_col - 1)
        move!(r, West)
    end

    return (center_row, center_col)
end

function mark_cross(r::Robot, center_row::Int, center_col::Int)
    # Крест
    for side in [Nord, Sud, West, Ost]
        while !isborder(r, side)
            putmarker!(r)
            move!(r, side)
        end
        putmarker!(r)
    end
end

function return_to_start(r::Robot, center_row::Int, center_col::Int)
    # Возврат в центр
    for _ in 1:center_row - 1
        move!(r, Sud)
    end
    for _ in 1:center_col - 1
        move!(r, Ost)
    end
end

function main(r::Robot
    center_row, center_col = find_center(r)

    mark_cross(r, center_row, center_col)

    return_to_start(r, center_row, center_col)
end

# Создаем робота и запускаем функцию
r = Robot(animate=true)
main(r)
