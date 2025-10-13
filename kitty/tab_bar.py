from kitty.rgb import Color
from kitty.utils import color_as_int
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    as_rgb,
    draw_title,
    DrawData,
    ExtraData,
    TabBarData
)

LEFT_SEP = ""
RIGHT_SEP = ""


def __draw(fg: Color, bg: Color, text: str, screen: Screen) -> int:
    if fg: screen.cursor.fg = as_rgb(color_as_int(fg))
    if bg: screen.cursor.bg = as_rgb(color_as_int(bg))
    if text: screen.draw(text)
    end = screen.cursor
    return end


def __draw_icon(screen: Screen, draw_data: DrawData, index: int) -> int:
    if index != 1:
        return 0
    fg, bg = screen.cursor.fg, screen.cursor.bg
    __draw(draw_data.default_bg, Color(157, 205, 105), "   ", screen)
    __draw(Color(157, 205, 105), draw_data.default_bg, RIGHT_SEP, screen)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    end = screen.cursor.x
    return end


def __draw_tab(
        draw_data: DrawData,
        screen: Screen,
        tab: TabBarData,
        max_tab_length: int,
        index: int,
        extra_data: ExtraData
) -> int:
    tab_bg = screen.cursor.bg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
    else:
        next_tab_bg = default_bg
    __draw(default_bg, None, RIGHT_SEP, screen)
    draw_title(draw_data, screen, tab, index, max_tab_length)
    screen.cursor.fg = tab_bg
    screen.cursor.bg = default_bg
    screen.draw(RIGHT_SEP)
    screen.cursor.fg = tab_bg
    screen.cursor.bg = next_tab_bg
    end = screen.cursor.x
    return end


def draw_tab(
        draw_data: DrawData,
        screen: Screen,
        tab: TabBarData,
        before: int,
        max_title_length: int,
        index: int,
        is_last: bool,
        extra_data: ExtraData,
) -> int:
    __draw_icon(screen, draw_data, index)
    __draw_tab(draw_data, screen, tab, max_title_length, index, extra_data)
    return screen.cursor.x
