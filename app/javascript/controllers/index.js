// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "controllers/application"

import ClickAnswerController from "controllers/click_answer_controller"
application.register("click-answer", ClickAnswerController)

import ColorController from "controllers/color_controller"
application.register("color", ColorController)

import HelloController from "controllers/hello_controller"
application.register("hello", HelloController)

import HoverColorController from "controllers/hover_color_controller"
application.register("hover-color", HoverColorController)

import MenuController from "controllers/menu_controller"
application.register("menu", MenuController)

import ModalController from "controllers/modal_controller"
application.register("modal", ModalController)

import SearchController from "controllers/search_controller"
application.register("search", SearchController)

import ShareController from "controllers/share_controller"
application.register("share", ShareController)

import ToggleController from "controllers/toggle_controller"
application.register("toggle", ToggleController)

import WordMarkController from "controllers/word_mark_controller"
application.register("word-mark", WordMarkController)

import TinymceController from "controllers/tinymce_controller"
application.register("tinymce", TinymceController)
