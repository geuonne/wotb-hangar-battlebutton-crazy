include ../Makefile

# LOL = yq '.battle | ... comments="" | .* as $$item ireduce ({}; .ru += $$item) | .[] | . style = "flow"' $< | sed 's/, /; /g; s/"/\\\"/g; s/(^.*$$)/"\1"/'

define add_element_string_pool =
$(eval string_pool != $(YAML_EVAL) '.$(target_element) | ... comments="" | .* as $$$$item ireduce ({}; .ru += $$$$item) | .[] | . style = "flow"' $< | $(SED) 's/, /; /g; s/"/\\\"/g; s/(^.*$$$$)/"\1"/')
$(eval _component = .Prototypes.[] | select(."name" == "BattleButton").components.UIDataLocalVarsComponent.[])
$(YAML_EVAL) '$(_component) += ([["vector<string>", "$(target_element)ButtonStringPool", "$(string_pool)"]] | ... style="flow" | .[].[] style = "double")' $@ $(_STASEP)
endef

BattleButton.yaml: button_strings.yaml
	$(foreach target_element,battle training,$(add_element_string_pool))
