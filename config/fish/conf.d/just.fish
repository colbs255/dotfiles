function __fish_just_complete_recipes
        just --list 2> /dev/null | tail -n +2 | awk '{
        command = $1;
        args = $0;
        desc = "";
        delim = "";
        sub(/^[[:space:]]*[^[:space:]]*/, "", args);
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", args);

        if (match(args, /#.*/)) {
          desc = substr(args, RSTART+2, RLENGTH);
          args = substr(args, 0, RSTART-1);
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", args);
        }

        gsub(/\+|=[`\'"][^`\'"]*[`\'"]/, "", args);
        gsub(/ /, ",", args);

        if (args != ""){
          args = "Args: " args;
        }

        if (args != "" && desc != "") {
          delim = "; ";
        }

        print command "\t" args delim desc
  }'
end

# don't suggest files right off
complete -c just -n "__fish_is_first_arg" --no-files

# complete recipes
complete -c just -a '(__fish_just_complete_recipes)'
