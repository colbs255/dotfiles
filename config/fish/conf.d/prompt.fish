set primary '7aa2f7'
set primary_accent black
set secondary '9ece6a'
set secondary_accent black

function fish_mode_prompt
    set_color $primary
    echo -n '░▒▓'

    set_color $primary_accent
    set_color --background $primary
    echo -n ' '
    switch $fish_bind_mode
        case default
            echo 'N'
        case insert
            echo 'I'
        case replace_one
            echo 'R'
        case visual
            echo 'V'
        case '*'
            echo'?'
    end
    echo -n ' '

    set_color $primary
    set_color --background $secondary
    echo -n ''

    set_color normal
end

function fish_prompt
    set_color $secondary_accent
    set_color --background $secondary
    echo -n ' '(prompt_pwd --full-length-dirs=0 --dir-length=0)

    set_color normal
    set_color $secondary
    echo -n ''

    set_color normal
    echo ''
    set_color $secondary
    echo '❯ '
end

function fish_greeting
    set_color blue
    echo Welcome $USER!
end

function fish_command_not_found
    echo Command not found: (set_color red)$argv[1]
end
