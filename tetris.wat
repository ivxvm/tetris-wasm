;; 10x20
;; 0 1 2 3 4 5 6 7 8 9
(module
    (memory 1)

    (global $cursor_row (mut i32) (i32.const 0))
    (global $cursor_col (mut i32) (i32.const 0))
    (global $rng (mut i32) (i32.const 0))
    (global $is_game_over (mut i32) (i32.const 0))

    (func $index (param $row i32) (param $col i32) (result i32)
        (i32.add
            (i32.const 9)
            (i32.add
                (i32.mul (i32.const 10) (local.get $row))
                (local.get $col))))

    (func $get_at (param $row i32) (param $col i32) (result i32)
        (i32.load
            (call $index (local.get $row) (local.get $col))))

    (func $set_at (param $row i32) (param $col i32) (param $val i32)
        (i32.store
            (call $index (local.get $row) (local.get $col))
            (local.get $val)))

    (func $land
        (local $offset_row i32)
        (local $offset_col i32)
        (local.set $offset_row (i32.const 0))
        (local.set $offset_col (i32.const 0))
        (loop $row_loop
            (loop $col_loop
                (call $set_at
                    (i32.add (global.get $cursor_row) (local.get $offset_row))
                    (i32.add (global.get $cursor_col) (local.get $offset_col))
                    (i32.load
                        (i32.add
                            (i32.mul (i32.const 3) (local.get $offset_row))
                            (local.get $offset_col))))
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
            (if (i32.load (i32.add (i32.mul (i32.const 3) (local.get $row)) (local.get $col)))
                (then (return (local.get $row))))
            (local.set $row
                (i32.sub (local.get $row) (i32.const 1)))
            (br_if $row_loop
                (i32.ne (local.get $row) (i32.const -1))))
        (local.get $row))

    (func $should_land (result i32)
        (local $row i32)
        (local.set $row (call $lnz_row (i32.const 0)))
        (if (i32.and
                (i32.ne (local.get $row) (i32.const -1))
                (call $get_at (local.get $row) (i32.const 0)))
            (then (return (i32.const 1))))
        (local.set $row (call $lnz_row (i32.const 1)))
        (if (i32.and
                (i32.ne (local.get $row) (i32.const -1))
                (call $get_at (local.get $row) (i32.const 1)))
            (then (return (i32.const 1))))
        (local.set $row (call $lnz_row (i32.const 2)))
        (if (i32.and
                (i32.ne (local.get $row) (i32.const -1))
                (call $get_at (local.get $row) (i32.const 2)))
            (then (return (i32.const 1))))
        (i32.const 0))

    (func $generate_figure (param $index i32)
        (block
            (block
                (block
                    (block
                        (block
                            (block
                                (local.get $index)
                                (br_table 0 1 2 3 4))
                            ;; 0 1 0
                            ;; 0 1 0
                            ;; 1 1 0
                            (i32.store (i32.const 0) (i32.const 0))
                            (i32.store (i32.const 1) (i32.const 1))
                            (i32.store (i32.const 2) (i32.const 0))
                            (i32.store (i32.const 3) (i32.const 0))
                            (i32.store (i32.const 4) (i32.const 1))
                            (i32.store (i32.const 5) (i32.const 0))
                            (i32.store (i32.const 6) (i32.const 1))
                            (i32.store (i32.const 7) (i32.const 1))
                            (i32.store (i32.const 8) (i32.const 0))
                            (return))
                        ;; 0 0 0
                        ;; 1 1 0
                        ;; 0 1 1
                        (i32.store (i32.const 0) (i32.const 0))
                        (i32.store (i32.const 1) (i32.const 0))
                        (i32.store (i32.const 2) (i32.const 0))
                        (i32.store (i32.const 3) (i32.const 1))
                        (i32.store (i32.const 4) (i32.const 1))
                        (i32.store (i32.const 5) (i32.const 0))
                        (i32.store (i32.const 6) (i32.const 0))
                        (i32.store (i32.const 7) (i32.const 1))
                        (i32.store (i32.const 8) (i32.const 1))
                        (return))
                    ;; 0 0 0
                    ;; 0 1 0
                    ;; 1 1 1
                    (i32.store (i32.const 0) (i32.const 0))
                    (i32.store (i32.const 1) (i32.const 0))
                    (i32.store (i32.const 2) (i32.const 0))
                    (i32.store (i32.const 3) (i32.const 0))
                    (i32.store (i32.const 4) (i32.const 1))
                    (i32.store (i32.const 5) (i32.const 0))
                    (i32.store (i32.const 6) (i32.const 1))
                    (i32.store (i32.const 7) (i32.const 1))
                    (i32.store (i32.const 8) (i32.const 1))
                    (return))
                ;; 0 0 0
                ;; 1 1 0
                ;; 1 1 0
                (i32.store (i32.const 0) (i32.const 0))
                (i32.store (i32.const 1) (i32.const 0))
                (i32.store (i32.const 2) (i32.const 0))
                (i32.store (i32.const 3) (i32.const 1))
                (i32.store (i32.const 4) (i32.const 1))
                (i32.store (i32.const 5) (i32.const 0))
                (i32.store (i32.const 6) (i32.const 1))
                (i32.store (i32.const 7) (i32.const 1))
                (i32.store (i32.const 8) (i32.const 0))
                (return))
            ;; 0 1 0
            ;; 0 1 0
            ;; 0 1 0
            (i32.store (i32.const 0) (i32.const 0))
            (i32.store (i32.const 1) (i32.const 1))
            (i32.store (i32.const 2) (i32.const 0))
            (i32.store (i32.const 3) (i32.const 0))
            (i32.store (i32.const 4) (i32.const 1))
            (i32.store (i32.const 5) (i32.const 0))
            (i32.store (i32.const 6) (i32.const 0))
            (i32.store (i32.const 7) (i32.const 1))
            (i32.store (i32.const 8) (i32.const 0))
            (return)))

    (func $rotate_figure
        (local $temp0 i32)
        (local $temp1 i32)
        (local $temp2 i32)
        (local $temp3 i32)
        (local $temp4 i32)
        (local $temp5 i32)
        (local $temp6 i32)
        (local $temp7 i32)
        (local $temp8 i32)
        (local.set $temp0 (i32.load (i32.const 0)))
        (local.set $temp1 (i32.load (i32.const 1)))
        (local.set $temp2 (i32.load (i32.const 2)))
        (local.set $temp3 (i32.load (i32.const 3)))
        (local.set $temp4 (i32.load (i32.const 4)))
        (local.set $temp5 (i32.load (i32.const 5)))
        (local.set $temp6 (i32.load (i32.const 6)))
        (local.set $temp7 (i32.load (i32.const 7)))
        (local.set $temp8 (i32.load (i32.const 8)))
        ;; 0 1 2
        ;; 3 4 5
        ;; 6 7 8
        ;; ->
        ;; 6 3 0
        ;; 7 4 1
        ;; 8 5 2
        (i32.store (i32.const 0) (local.get $temp6))
        (i32.store (i32.const 1) (local.get $temp3))
        (i32.store (i32.const 2) (local.get $temp0))
        (i32.store (i32.const 3) (local.get $temp7))
        (i32.store (i32.const 4) (local.get $temp4))
        (i32.store (i32.const 5) (local.get $temp1))
        (i32.store (i32.const 6) (local.get $temp8))
        (i32.store (i32.const 7) (local.get $temp5))
        (i32.store (i32.const 8) (local.get $temp2)))

    (func $process_filled_rows
        (local $row i32)
        (local $col i32)
        (local $has_empty_spaces i32)
        (local.set $row (i32.const 0))
        (loop $row_loop
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

    (func $tick
        (if (call $should_land)
            (then
                (call $land)
                (call $process_filled_rows)
                (call $generate_figure (global.get $rng))
                (global.set $cursor_row (i32.const 0))
                (global.set $cursor_col (i32.const 4))
                (if (call $should_land)
                    (global.set $is_game_over (i32.const 1))))
            (else
                (global.set $cursor_row
                    (i32.add (global.get $cursor_row) (i32.const 1)))))))
