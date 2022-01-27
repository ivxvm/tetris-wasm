;; 10x20
;;
;;
;;
(module
    (memory 1)
    (global $cursor_row (mut i32))
    (global $cursor_col (mut i32))
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
            (br_if $row_loop
                (i32.load (i32.add (i32.mul (i32.const 3) (local.get $row)) (local.get $col))))
            (local.set $row
                (i32.sub (local.get $row) (i32.const 1))))
        (local.get $row))
    (func $should_land
        )



    (func $tick
        ()))
