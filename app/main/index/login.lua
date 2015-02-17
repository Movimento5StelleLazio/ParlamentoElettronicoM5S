ui.tag {
    tag = "noscript",
    content = function()
        slot.put(_ "JavaScript is disabled or not available.")
    end
}

execute.view { module = "index", view = "_lang_chooser" }

ui.title(_ "Login")
app.html_title.title = _ "Login"

if config.motd_public then
    local help_text = config.motd_public
    ui.container {
        attr = { class = "wiki motd" },
        content = function()
            slot.put(format.wiki_text(help_text))
        end
    }
end

if app.session:has_access("anonymous") then
    ui.tag {
        tag = 'p',
        content = _ 'You need to be logged in, to use all features of this system.'
    }
else
    ui.tag { tag = "p", content = _ "Closed user group, please login to participate." }
end

--[[ui.form {
    attr = { class = "login" },
    module = 'index',
    action = 'login',
    routing = {
        ok = {
            mode = 'redirect',
            module = param.get("redirect_module") or "index",
            view = param.get("redirect_view") or "index",
            id = param.get("redirect_id"),
        },
        error = {
            mode = 'forward',
            module = 'index',
            view = 'login',
        }
    },
    content = function()
        ui.field.text {
            attr = { id = "username_field" },
            label = _ 'login name',
            html_name = 'login',
            value = ''
        }
        ui.script { script = 'document.getElementById("username_field").focus();' }
        ui.field.password {
            label = _ 'Password',
            html_name = 'password',
            value = ''
        }
        ui.submit {
            text = _ 'Login'
        }
    end
}]]

ui.form {
    attr = { id = "login_div", class = "login" },
    module = 'index',
    action = 'login',
    routing = {
        ok = {
            mode = 'redirect',
            module = param.get("redirect_module") or "index",
            view = param.get("redirect_view") or "index",
            id = param.get("redirect_id"),
        },
        error = {
            mode = 'forward',
            module = 'index',
            view = 'login',
        }
    },
    content = function()
        ui.tag {
                        tag = "fieldset",
                        content = function()
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "legend", attr = { class = "span12 text-center" }, content = _ "Insert user name and password to access:" }
                                end
                            }

                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "label", attr = { class = "span4" }, content = _ 'login name' }
                                    ui.tag {
                                        tag = "input",
                                        attr = { id = "username_field", type = "text", placeholder = _ 'login name', class = "span8 input-large", name = "login" },
                                        content = ''
                                    }
                                end
                            }

                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "label", attr = { class = "span4" }, content = _ 'Password' }
                                    ui.script { script = 'document.getElementById("username_field").focus();' }
                                    ui.tag { tag = "input", attr = { id = "password_field", type = "password", placeholder = _ 'Password', class = "span8 input-large", name = "password" }, content = '' }
                                end
                            }
                            
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "label", attr = { class = "span4" }, content = _ 'OTP' }
                                    ui.script { script = 'document.getElementById("username_field").focus();' }
                                    ui.tag { tag = "input", attr = { id = "otp_field", type = "otp", placeholder = _ 'OTP', class = "span8 input-large", name = "otp" }, content = '' }
                                end
                            }

                            ui.container {
                                attr = { class = "row-fluid text-center" },
                                content = function()
                                    ui.container {
                                        attr = { class = "span6 offset3" },
                                        content = function()
                                            --[[ui.tag {
                                                tag = "button",
                                                attr = { type = "submit", class = "btn btn-primary btn-large large_btn spaceline fixclick" },
                                                content = function()
                                                    ui.heading { level = 3, attr = { class = "inline-block" }, content = _ "Login" }
                                                end
                                            }]]
                                            ui.script { static = "js/auth.js" }
                                            ui.tag {
                                            		tag = "a",
                                            		attr = { href = "javascript:void(0)", onclick="checkOtpToken();", class = "btn btn-primary btn-large large_btn spaceline fixclick" },
                                            		content = function()
                                                    ui.heading { level = 3, attr = { class = "inline-block" }, content = _ "Login" }
                                                end
                                            }
                                        end
                                    }
                                end
                             }
                        end
                    }
    end
}
