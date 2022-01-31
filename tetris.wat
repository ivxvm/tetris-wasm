(module
    (func $debug (import "js" "debug") (param i32))

    (memory (export "memory") 1)

    (global $cursor_row (export "cursorRow") (mut i32) (i32.const 0))
    (global $cursor_col (export "cursorColumn") (mut i32) (i32.const 0))
    (global $rng (export "rng") (mut i32) (i32.const 0))
    (global $is_game_over (export "isGameOver") (mut i32) (i32.const 0))
    (global $score (export "score") (mut i32) (i32.const 0))

    (func $index (param $row i32) (param $col i32) (result i32)
        (i32.mul
            (i32.const 4)
            (i32.add
                (i32.const 9)
                (i32.add
                    (i32.mul (i32.const 10) (local.get $row))
                    (local.get $col)))))

    (func $get_at (param $row i32) (param $col i32) (result i32)
        (if (i32.ge_s (local.get $col) (i32.const 10)) (then (return (i32.const 1))))
        (if (i32.le_s (local.get $col) (i32.const -1)) (then (return (i32.const 1))))
        (if (i32.ge_s (local.get $row) (i32.const 20)) (then (return (i32.const 1))))
        (i32.load
            (call $index (local.get $row) (local.get $col))))

    (func $set_at (param $row i32) (param $col i32) (param $val i32)
        (i32.store
            (call $index (local.get $row) (local.get $col))
            (local.get $val)))

    (func $land
        (local $offset_row i32)
        (local $offset_col i32)
        (local $target_val i32)
        (local.set $offset_row (i32.const 0))
        (loop $row_loop
            (local.set $offset_col (i32.const 0))
            (loop $col_loop
                (local.set $target_val
                    (i32.load
                        (i32.mul
                            (i32.const 4)
                            (i32.add
                                (i32.mul (i32.const 3) (local.get $offset_row))
                                (local.get $offset_col)))))
                (if (local.get $target_val)
                    (call $set_at
                        (i32.add (global.get $cursor_row) (local.get $offset_row))
                        (i32.add (global.get $cursor_col) (local.get $offset_col))
                        (local.get $target_val)))
                (local.set $offset_col
                    (i32.add (i32.const 1) (local.get $offset_col)))
                (br_if $col_loop
                    (i32.ne (i32.const 3) (local.get $offset_col))))
            (local.set $offset_row
                (i32.add (i32.const 1) (local.get $offset_row)))
            (br_if $row_loop
                (i32.ne (i32.const 3) (local.get $offset_row)))))

    (func $lnz_row (param $col i32) (result i32)
        (local $row i32)
        (local.set $row (i32.const 2))
        (loop $row_loop
            (if (i32.load
                    (i32.mul
                        (i32.const 4)
                        (i32.add
                            (i32.mul (i32.const 3) (local.get $row))
                            (local.get $col))))
                (then (return (local.get $row))))
            (local.set $row
                (i32.sub (local.get $row) (i32.const 1)))
            (br_if $row_loop
                (i32.ne (local.get $row) (i32.const -1))))
        (local.get $row))

    (func $should_land (result i32)
        (local $offset_row i32)
        (local $target_row i32)
        (local.set $offset_row (call $lnz_row (i32.const 0)))
        (local.set $target_row
            (i32.add
                (i32.const 1)
                (i32.add (global.get $cursor_row) (local.get $offset_row))))
        (if (i32.eq (local.get $target_row) (i32.const 20)) (then (return (i32.const 1))))
        (if (i32.and
                (i32.ne (local.get $offset_row) (i32.const -1))
                (call $get_at
                    (local.get $target_row)
                    (global.get $cursor_col)))
            (then (return (i32.const 1))))
        (local.set $offset_row (call $lnz_row (i32.const 1)))
        (local.set $target_row
            (i32.add
                (i32.const 1)
                (i32.add (global.get $cursor_row) (local.get $offset_row))))
        (if (i32.eq (local.get $target_row) (i32.const 20)) (then (return (i32.const 1))))
        (if (i32.and
                (i32.ne (local.get $offset_row) (i32.const -1))
                (call $get_at
                    (local.get $target_row)
                    (i32.add (global.get $cursor_col) (i32.const 1))))
            (then (return (i32.const 1))))
        (local.set $offset_row (call $lnz_row (i32.const 2)))
        (local.set $target_row
            (i32.add
                (i32.const 1)
                (i32.add (global.get $cursor_row) (local.get $offset_row))))
        (if (i32.eq (local.get $target_row) (i32.const 20)) (then (return (i32.const 1))))
        (if (i32.and
                (i32.ne (local.get $offset_row) (i32.const -1))
                (call $get_at
                    (local.get $target_row)
                    (i32.add (global.get $cursor_col) (i32.const 2))))
            (then (return (i32.const 1))))
        (i32.const 0))

    (func $generate_figure (param $index i32)
        (block
            (block
                (block
                    (block
                        (block
                            (block
                                (block
                                    (block
                                        (local.get $index)
                                        (br_table 0 1 2 3 4 5 6))
                                    ;; 0 1 0
                                    ;; 0 1 0
                                    ;; 1 1 0
                                    (i32.store (i32.const 00) (i32.const 0))
                                    (i32.store (i32.const 04) (i32.const 1))
                                    (i32.store (i32.const 08) (i32.const 0))
                                    (i32.store (i32.const 12) (i32.const 0))
                                    (i32.store (i32.const 16) (i32.const 1))
                                    (i32.store (i32.const 20) (i32.const 0))
                                    (i32.store (i32.const 24) (i32.const 1))
                                    (i32.store (i32.const 28) (i32.const 1))
                                    (i32.store (i32.const 32) (i32.const 0))
                                    (return))
                                ;; 0 0 0
                                ;; 1 1 0
                                ;; 0 1 1
                                (i32.store (i32.const 00) (i32.const 0))
                                (i32.store (i32.const 04) (i32.const 0))
                                (i32.store (i32.const 08) (i32.const 0))
                                (i32.store (i32.const 12) (i32.const 1))
                                (i32.store (i32.const 16) (i32.const 1))
                                (i32.store (i32.const 20) (i32.const 0))
                                (i32.store (i32.const 24) (i32.const 0))
                                (i32.store (i32.const 28) (i32.const 1))
                                (i32.store (i32.const 32) (i32.const 1))
                                (return))
                            ;; 0 0 0
                            ;; 0 1 0
                            ;; 1 1 1
                            (i32.store (i32.const 00) (i32.const 0))
                            (i32.store (i32.const 04) (i32.const 0))
                            (i32.store (i32.const 08) (i32.const 0))
                            (i32.store (i32.const 12) (i32.const 0))
                            (i32.store (i32.const 16) (i32.const 1))
                            (i32.store (i32.const 20) (i32.const 0))
                            (i32.store (i32.const 24) (i32.const 1))
                            (i32.store (i32.const 28) (i32.const 1))
                            (i32.store (i32.const 32) (i32.const 1))
                            (return))
                        ;; 0 0 0
                        ;; 1 1 0
                        ;; 1 1 0
                        (i32.store (i32.const 00) (i32.const 0))
                        (i32.store (i32.const 04) (i32.const 0))
                        (i32.store (i32.const 08) (i32.const 0))
                        (i32.store (i32.const 12) (i32.const 1))
                        (i32.store (i32.const 16) (i32.const 1))
                        (i32.store (i32.const 20) (i32.const 0))
                        (i32.store (i32.const 24) (i32.const 1))
                        (i32.store (i32.const 28) (i32.const 1))
                        (i32.store (i32.const 32) (i32.const 0))
                        (return))
                    ;; 0 1 0
                    ;; 0 1 0
                    ;; 0 1 0
                    (i32.store (i32.const 00) (i32.const 0))
                    (i32.store (i32.const 04) (i32.const 1))
                    (i32.store (i32.const 08) (i32.const 0))
                    (i32.store (i32.const 12) (i32.const 0))
                    (i32.store (i32.const 16) (i32.const 1))
                    (i32.store (i32.const 20) (i32.const 0))
                    (i32.store (i32.const 24) (i32.const 0))
                    (i32.store (i32.const 28) (i32.const 1))
                    (i32.store (i32.const 32) (i32.const 0))
                    (return))
                ;; 0 1 0
                ;; 0 1 0
                ;; 1 1 1
                (i32.store (i32.const 00) (i32.const 0))
                (i32.store (i32.const 04) (i32.const 1))
                (i32.store (i32.const 08) (i32.const 0))
                (i32.store (i32.const 12) (i32.const 0))
                (i32.store (i32.const 16) (i32.const 1))
                (i32.store (i32.const 20) (i32.const 0))
                (i32.store (i32.const 24) (i32.const 1))
                (i32.store (i32.const 28) (i32.const 1))
                (i32.store (i32.const 32) (i32.const 1))
                (return))
            ;; 0 0 0
            ;; 0 1 0
            ;; 0 1 1
            (i32.store (i32.const 00) (i32.const 0))
            (i32.store (i32.const 04) (i32.const 0))
            (i32.store (i32.const 08) (i32.const 0))
            (i32.store (i32.const 12) (i32.const 0))
            (i32.store (i32.const 16) (i32.const 1))
            (i32.store (i32.const 20) (i32.const 0))
            (i32.store (i32.const 24) (i32.const 0))
            (i32.store (i32.const 28) (i32.const 1))
            (i32.store (i32.const 32) (i32.const 1))
            (return)))

    (func $rotate_figure (export "rotateFigure")
        (local $temp0 i32)
        (local $temp1 i32)
        (local $temp2 i32)
        (local $temp3 i32)
        (local $temp4 i32)
        (local $temp5 i32)
        (local $temp6 i32)
        (local $temp7 i32)
        (local $temp8 i32)
        (local.set $temp0 (i32.load (i32.const  0)))
        (local.set $temp1 (i32.load (i32.const  4)))
        (local.set $temp2 (i32.load (i32.const  8)))
        (local.set $temp3 (i32.load (i32.const 12)))
        (local.set $temp4 (i32.load (i32.const 16)))
        (local.set $temp5 (i32.load (i32.const 20)))
        (local.set $temp6 (i32.load (i32.const 24)))
        (local.set $temp7 (i32.load (i32.const 28)))
        (local.set $temp8 (i32.load (i32.const 32)))
        (if (i32.and
                (local.get $temp0)
                (call $get_at
                    (global.get $cursor_row)
                    (i32.add (global.get $cursor_col) (i32.const 2))))
            (then (return)))
        (if (i32.and
                (local.get $temp1)
                (call $get_at
                    (i32.add (global.get $cursor_row) (i32.const 1))
                    (i32.add (global.get $cursor_col) (i32.const 2))))
            (then (return)))
        (if (i32.and
                (local.get $temp2)
                (call $get_at
                    (i32.add (global.get $cursor_row) (i32.const 2))
                    (i32.add (global.get $cursor_col) (i32.const 2))))
            (then (return)))
        (if (i32.and
                (local.get $temp3)
                (call $get_at
                    (global.get $cursor_row)
                    (i32.add (global.get $cursor_col) (i32.const 1))))
            (then (return)))
        (if (i32.and
                (local.get $temp5)
                (call $get_at
                    (i32.add (global.get $cursor_row) (i32.const 2))
                    (i32.add (global.get $cursor_col) (i32.const 1))))
            (then (return)))
        (if (i32.and
                (local.get $temp6)
                (call $get_at
                    (global.get $cursor_row)
                    (global.get $cursor_col)))
            (then (return)))
        (if (i32.and
                (local.get $temp7)
                (call $get_at
                    (i32.add (global.get $cursor_row) (i32.const 1))
                    (global.get $cursor_col)))
            (then (return)))
        (if (i32.and
                (local.get $temp8)
                (call $get_at
                    (i32.add (global.get $cursor_row) (i32.const 2))
                    (global.get $cursor_col)))
            (then (return)))
        ;; 0 1 2
        ;; 3 4 5
        ;; 6 7 8
        ;; ->
        ;; 6 3 0
        ;; 7 4 1
        ;; 8 5 2
        (i32.store (i32.const 00) (local.get $temp6))
        (i32.store (i32.const 04) (local.get $temp3))
        (i32.store (i32.const 08) (local.get $temp0))
        (i32.store (i32.const 12) (local.get $temp7))
        (i32.store (i32.const 16) (local.get $temp4))
        (i32.store (i32.const 20) (local.get $temp1))
        (i32.store (i32.const 24) (local.get $temp8))
        (i32.store (i32.const 28) (local.get $temp5))
        (i32.store (i32.const 32) (local.get $temp2)))

    (func $move_right (export "moveRight")
        (local $col_offset i32)
        (local $row i32)
        (local $col i32)
        (local.set $row (global.get $cursor_row))
        (block
            (if (i32.load (i32.const 0)) (then (local.set $col_offset (i32.const 1)) (br 0)))
            (if (i32.load (i32.const 4)) (then (local.set $col_offset (i32.const 2)) (br 0)))
            (if (i32.load (i32.const 8)) (then (local.set $col_offset (i32.const 3)) (br 0))))
        (local.set $col (i32.add (global.get $cursor_col) (local.get $col_offset)))
        (if (i32.eq (local.get $col) (i32.const 10)) (then (return)))
        (if (call $get_at (local.get $row) (local.get $col)) (then (return)))
        (local.set $row (i32.add (i32.const 1) (local.get $row)))
        (block
            (if (i32.load (i32.const 12)) (then (local.set $col_offset (i32.const 1)) (br 0)))
            (if (i32.load (i32.const 16)) (then (local.set $col_offset (i32.const 2)) (br 0)))
            (if (i32.load (i32.const 20)) (then (local.set $col_offset (i32.const 3)) (br 0))))
        (local.set $col (i32.add (global.get $cursor_col) (local.get $col_offset)))
        (if (i32.eq (local.get $col) (i32.const 10)) (then (return)))
        (if (call $get_at (local.get $row) (local.get $col)) (then (return)))
        (local.set $row (i32.add (i32.const 1) (local.get $row)))
        (block
            (if (i32.load (i32.const 24)) (then (local.set $col_offset (i32.const 1)) (br 0)))
            (if (i32.load (i32.const 28)) (then (local.set $col_offset (i32.const 2)) (br 0)))
            (if (i32.load (i32.const 32)) (then (local.set $col_offset (i32.const 3)) (br 0))))
        (local.set $col (i32.add (global.get $cursor_col) (local.get $col_offset)))
        (if (i32.eq (local.get $col) (i32.const 10)) (then (return)))
        (if (call $get_at (local.get $row) (local.get $col)) (then (return)))
        (global.set $cursor_col
            (i32.add (global.get $cursor_col) (i32.const 1))))

    (func $move_left (export "moveLeft")
        (local $col_offset i32)
        (local $row i32)
        (local $col i32)
        (local.set $row (global.get $cursor_row))
        (block
            (if (i32.load (i32.const 8)) (then (local.set $col_offset (i32.const  1)) (br 0)))
            (if (i32.load (i32.const 4)) (then (local.set $col_offset (i32.const  0)) (br 0)))
            (if (i32.load (i32.const 0)) (then (local.set $col_offset (i32.const -1)) (br 0))))
        (local.set $col (i32.add (global.get $cursor_col) (local.get $col_offset)))
        (if (i32.eq (local.get $col) (i32.const -1)) (then (return)))
        (if (call $get_at (local.get $row) (local.get $col)) (then (return)))
        (local.set $row (i32.add (i32.const 1) (local.get $row)))
        (block
            (if (i32.load (i32.const 20)) (then (local.set $col_offset (i32.const  1)) (br 0)))
            (if (i32.load (i32.const 16)) (then (local.set $col_offset (i32.const  0)) (br 0)))
            (if (i32.load (i32.const 12)) (then (local.set $col_offset (i32.const -1)) (br 0))))
        (local.set $col (i32.add (global.get $cursor_col) (local.get $col_offset)))
        (if (i32.eq (local.get $col) (i32.const -1)) (then (return)))
        (if (call $get_at (local.get $row) (local.get $col)) (then (return)))
        (local.set $row (i32.add (i32.const 1) (local.get $row)))
        (block
            (if (i32.load (i32.const 32)) (then (local.set $col_offset (i32.const  1)) (br 0)))
            (if (i32.load (i32.const 28)) (then (local.set $col_offset (i32.const  0)) (br 0)))
            (if (i32.load (i32.const 24)) (then (local.set $col_offset (i32.const -1)) (br 0))))
        (local.set $col (i32.add (global.get $cursor_col) (local.get $col_offset)))
        (if (i32.eq (local.get $col) (i32.const -1)) (then (return)))
        (if (call $get_at (local.get $row) (local.get $col)) (then (return)))
        (global.set $cursor_col
            (i32.sub (global.get $cursor_col) (i32.const 1))))

    (func $process_filled_rows
        (local $row i32)
        (local $col i32)
        (local $has_empty_spaces i32)
        (local $score_multiplier i32)
        (local.set $score_multiplier (i32.const 1))
        (local.set $row (i32.const 0))
        (loop $row_loop
            (local.set $has_empty_spaces (i32.const 0))
            (local.set $col (i32.const 0))
            (block $col_loop_block
                (loop $col_loop
                    (if (i32.eqz (call $get_at (local.get $row) (local.get $col)))
                        (then
                            (local.set $has_empty_spaces (i32.const 1))
                            (br $col_loop_block)))
                    (local.set $col
                        (i32.add (i32.const 1) (local.get $col)))
                    (br_if $col_loop
                        (i32.ne (local.get $col) (i32.const 10)))))
            (if (i32.eqz (local.get $has_empty_spaces))
                (then
                    (global.set $score
                        (i32.add
                            (global.get $score)
                            (i32.mul (local.get $score_multiplier) (i32.const 10))))
                    (local.set $score_multiplier
                        (i32.mul (local.get $score_multiplier) (i32.const 2)))
                    (call $shift_rows (local.get $row))
                    (call $clear_row (i32.const 0)))
                (else
                    (local.set $row
                        (i32.add (i32.const 1) (local.get $row)))))
            (br_if $row_loop
                (i32.ne (local.get $row) (i32.const 20)))))

    (func $shift_rows (param $target_row i32)
        (local $row i32)
        (local $col i32)
        (local.set $row (local.get $target_row))
        (loop $row_loop
            (local.set $col (i32.const 0))
            (loop $col_loop
                (call $set_at (local.get $row) (local.get $col)
                    (call $get_at (i32.sub (local.get $row) (i32.const 1)) (local.get $col)))
                (local.set $col
                    (i32.add (i32.const 1) (local.get $col)))
                (br_if $col_loop
                    (i32.ne (local.get $col) (i32.const 10))))
            (local.set $row
                (i32.sub (local.get $row) (i32.const 1)))
            (br_if $row_loop
                (i32.ne (local.get $row) (i32.const 0)))))

    (func $clear_row (param $target_row i32)
        (local $col i32)
        (local.set $col (i32.const 0))
        (loop $col_loop
            (call $set_at (local.get $target_row) (local.get $col) (i32.const 0))
            (local.set $col
                (i32.add (i32.const 1) (local.get $col)))
            (br_if $col_loop
                (i32.ne (local.get $col) (i32.const 10)))))

    (func (export "init")
        (memory.fill (i32.const 0) (i32.const 512) (i32.const 0))
        (global.set $score (i32.const 0)))

    (func $reset_figure (export "resetFigure")
        (call $generate_figure (global.get $rng))
        (global.set $cursor_row (i32.const 0))
        (global.set $cursor_col (i32.const 4)))

    (func $tick (export "tick")
        (if (call $should_land)
            (then
                (call $land)
                (call $process_filled_rows)
                (call $reset_figure)
                (if (call $should_land)
                    (global.set $is_game_over (i32.const 1))))
            (else
                (global.set $cursor_row
                    (i32.add (global.get $cursor_row) (i32.const 1)))))))
