import argparse
from sys import stdin
from typing import Any

Mat = list[list[str]]
FullMat = list[list[list[str]]]


def get_args() -> dict[str, Any]:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--compact", "-c", action="store_true", help="Trim spaces"
    )
    parser.add_argument(
        "--arrange-lists", "-l", action="store_true", help="Arrange lists"
    )
    parser.add_argument(
        "--single-line-lists", "-s", action="store_true", help="Put lists on a single line separated by ';'"
    )
    args = parser.parse_args()
    return vars(args)


def read() -> Mat:
    result = []
    for line in stdin:
        result.append([x.strip() for x in line.replace("\n", "").split(",")])
    return result


def get_num_non_empty_columns(rows: Mat) -> int:
    num_columns = 0
    for r in rows:
        size = len(r)
        for c in r[::-1]:
            if len(c) > 0:
                break
            size -= 1
        num_columns = max(num_columns, size)
    return num_columns


def clean_rows_of_extra_commas_inplace(num_columns: int, rows: Mat) -> Mat:
    for i, row in enumerate(rows):
        rows[i] = row[:num_columns]
    return rows


def join_rows(num_columns: int, rows: Mat) -> FullMat:
    result = []
    previous_row_size = 0
    for r in rows:
        if len(r) == 0:
            continue
        row_size = sum(len(x) for x in r)
        if len(r[0]) > 0 or row_size == 0 or previous_row_size == 0:
            result.append([])
            for i in range(num_columns):
                result[-1].append([])
        for i, c in enumerate(r):
            c = c.strip()
            if len(c) > 0:
                strp = [x.strip() for x in c.split(";")]
                result[-1][i] += [x for x in strp if len(x) > 0]
        previous_row_size = row_size
    return result


def make_lists_single_line(full_rows: FullMat):
    for r in full_rows:
        for i, c in enumerate(r):
            r[i] = [';'.join(c)]
    return full_rows


def get_num_cols_per_row(full_rows: FullMat) -> list[int]:
    result: list[int] = []
    for r in full_rows:
        result.append(0)
        for c in r:
            result[-1] = max(result[-1], len(c))
    return result


def expand_rows(
    num_columns: int, full_rows: FullMat, num_cols_per_row: list[int]
) -> Mat:
    result: Mat = []
    for ir, r in enumerate(full_rows):
        if num_cols_per_row[ir] == 0:
            result.append([""] * num_columns)
        for entry_id in range(num_cols_per_row[ir]):
            result.append([""] * num_columns)
            for ic in range(num_columns):
                if entry_id < len(r[ic]):
                    result[-1][ic] = r[ic][entry_id]
    return result


def get_longest_field_per_column(num_columns: int, rows: Mat) -> list[int]:
    result = [0] * num_columns
    for r in rows:
        for i, c in enumerate(r):
            result[i] = max(result[i], len(c))
    return result


def get_string(column_lengths: list[int], rows: Mat) -> str:
    result = []
    for r in rows:
        str_row = []
        for c, cl in zip(r, column_lengths):
            str_row.append(c.rjust(cl))
        result.append(",".join(str_row))
    return "\n".join(result)


def main():
    args = get_args()
    rows = read()
    num_columns = get_num_non_empty_columns(rows)
    rows = clean_rows_of_extra_commas_inplace(num_columns, rows)
    if args["compact"]:
        column_lengths = [0] * num_columns
    else:
        if args["arrange_lists"]:
            full_rows = join_rows(num_columns, rows)
            if args["single_line_lists"]:
                full_rows = make_lists_single_line(full_rows)
            num_cols_per_row = get_num_cols_per_row(full_rows)
            rows = expand_rows(num_columns, full_rows, num_cols_per_row)
        column_lengths = get_longest_field_per_column(num_columns, rows)
    print(get_string(column_lengths, rows))


if __name__ == "__main__":
    main()
