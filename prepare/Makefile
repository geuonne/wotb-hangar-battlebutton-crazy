include /home/geuonne/.local/src/wotb-mods/wotb-hangar-battlebutton-crazy/definitions.mk

target_language = ru
button_types = battle training

define add_control_string_pool =
# Label of battle button is named buttonText, not battleButtonText
$(eval _i_element != $(ECHO) $(i_element) | $(SED) 's/battle//g')
$(eval _string_pool_var = [["string", "$(_i_element)buttonText", "$(i_element)buttonStringPool[rand(Size($(i_element)buttonStringPool))]"]] | ... style = "flow" | .[].[] style = "double")
$(eval _component = (.Prototypes.[] | select(."name" == "BattleButton")).components.UIDataLocalBindingsComponent.data)
$(YQ) --inplace '$(_component) += ($(_string_pool_var))' mod_$@ $(_STASEP)

$(eval string_pool != $(YAML_EVAL) '.$(i_element) | ... comments="" | .* as $$$$item ireduce ({}; .$(target_language) += $$$$item) | .[] | . style = "flow"' $< | $(SED) 's/", "/"; "/g; s/"/\\\"/g; s/\(.*\)/"\1"/g')
$(eval _component = (.Prototypes.[] | select(."name" == "BattleButton")).components.UIDataLocalVarsComponent.data)
$(eval _string_pool_formatted = [["vector<string>", "$(i_element)buttonStringPool", $(string_pool)]] | ... style = "flow" | .[].[] style = "double")
$(YQ) --inplace '$(_component) += ($(_string_pool_formatted))' mod_$@ $(_STASEP)
endef

define training_button_setup =
$(eval _component = ((((((.Prototypes.[] | select(."name" == "BattleButton")).children.[] | select(."name" == "ButtonWrapper")).children.[] | select(."name" == "BattleButtonWrapper")).children.[] | select(."name" == "TrainingButton")).children.[] | select(."name" == "Content")).children.[] | select(."name" == "Text")))
$(eval _data = ({"bindings": [["UITextComponent.text", "$(i_element)buttonText"]]} | .. style = "double" | .[].[] style = "flow"))
$(YQ) --inplace '$(_component) += $(_data)' mod_$@
endef

BattleButton.yaml: button_strings.yaml
	$(CP) $@ mod_$@
	$(foreach i_element,$(button_types),$(add_control_string_pool))
	$(foreach i_element,$(button_types),$($(i_element)_button_setup))
	$(CP) mod_$@ $(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/$@
