include ../definitions.mk


target_language = ru
# Space-separated list of button types
button_types = battle training
button_components = BattleWrapper TrainingButton
button_width = 344.0

define battle_button_setup =
# Delete original buttonText variable first as duplicates are not allowed
$(eval _component = (.Prototypes.[] | select(."name" == "BattleButton")).components.UIDataLocalBindingsComponent.data)
$(YQ) --inplace 'del($(_component).[] | select(.[1] == "buttonText"))' mod_$@ $(_STASEP)

# Set button width
$(eval _component = ((((.Prototypes.[] | select(."name" == "BattleButton")).children.[] | select(."name" == "ButtonWrapper")).children.[] | select(."name" == "BattleButtonWrapper")).children.[] | select(."name" == "BattleWrapper")))
$(eval _component_element = $(_component).components.SizePolicy.horizontalValue)
$(eval _data = $(button_width))
$(YQ) --inplace '$(_component_element) = $(_data)' mod_$@ $(_STASEP)

$(eval _component_element = (($(_component).children.[] | select(."name" == "Content")).children.[] | select(."name" == "ActiveBg")).components.Background.drawType)
$(eval _data = ("DRAW_SCALE_TO_RECT" | .. style = "double"))
$(YQ) --inplace '$(_component_element) = ($(_data))' mod_$@ $(_STASEP)

$(eval _component_element = (($(_component).children.[] | select(."name" == "battle_top")).position[0]))
$(eval _data = $(button_width) / 2$(_YQ_forcefloat))
$(YQ) --inplace '$(_component_element) = ($(_data))' mod_$@ $(_STASEP)
endef

define training_button_setup =
# Make text of the training button the value of randomized string
$(eval _component = ((((((.Prototypes.[] | select(."name" == "BattleButton")).children.[] | select(."name" == "ButtonWrapper")).children.[] | select(."name" == "BattleButtonWrapper")).children.[] | select(."name" == "TrainingButton")).children.[] | select(."name" == "Content")).children.[] | select(."name" == "Text")))
$(eval _data = ({"bindings": [["UITextComponent.text", "$(i_element)buttonText"]]} | .. style = "double" | .[].[] style = "flow"))
$(YQ) --inplace '$(_component) += $(_data)' mod_$@ $(_STASEP)
endef

define add_control_string_pool =
# Add variable where randomized quote is stored
$(eval _component = (.Prototypes.[] | select(."name" == "BattleButton")).components.UIDataLocalBindingsComponent.data)
# Label of battle button is named buttonText, not battleButtonText
$(eval _i_element != $(ECHO) $(i_element) | $(SED) 's/battle//g')
$(eval _string_pool_var = [["string", "$(_i_element)buttonText", "$(i_element)buttonStringPool[rand(Size($(i_element)buttonStringPool))]"]] | ... comments = "" | ... style = "flow" | .[].[] style = "double")
$(YQ) --inplace '$(_component) += ($(_string_pool_var))' mod_$@ $(_STASEP)

# Add string pool itself
# All entries
$(eval _component = (.Prototypes.[] | select(."name" == "BattleButton")).components.UIDataLocalVarsComponent.data)
$(eval all_entries = [.$(target_language).$(i_element).*, .*.$(i_element).original, (.$(target_language).* | to_entries | .[] | select(.key == "original").value), .any.$(i_element).*, .any.common.*, .$(target_language).common.*])
$(eval string_pool != $(YQ) eval-all '$(all_entries) | flatten | ... comments = "" | .. style = "double" | unique | . style = "flow"' $^ | $(SED) 's/", "/"; "/g; s/\("@@\|@@"\)//g; s/\\\"/"/g; s/"/\\\"/g; s/\(.*\)/"\1"/')
$(eval _string_pool_formatted = [["vector<string>", "$(i_element)buttonStringPool", $(string_pool)]] | ... style = "flow" | .[].[] style = "double")
$(YQ) --inplace '$(_component) += ($(_string_pool_formatted))' mod_$@ $(_STASEP)
endef

define add_button_effects =
# Add effect bindings
$(eval _component = ((((.Prototypes.[] | select(."name" == "BattleButton")).children.[] | select(."name" == "ButtonWrapper")).children.[] | select(."name" == "BattleButtonWrapper")).children.[] | select(."name" == "$(i_component)")).bindings)
$(YQ) --inplace eval-all '$(_component) += (.bindings) | select(filename == "mod_BattleButton.yaml") | ... comments = ""' mod_$@ effects.yaml $(_STASEP)
endef

BattleButton.yaml: button_entries/button_entries_*.yaml
	$(CP) $@ mod_$@
	$(foreach i_element,$(button_types),$($(i_element)_button_setup))
# Add dynamic variables for specified target language & common quotes
	$(YQ) --inplace eval-all '(.Prototypes.[] | select(."name" == "BattleButton")).components.UIDataLocalVarsComponent.data += ([.any.dynamic_vars, .$(target_language).dynamic_vars] | flatten(1)) | select(filename == "mod_$@")' mod_$@ $^
	$(foreach i_element,$(button_types),$(add_control_string_pool))
# Add effect variables
	$(YQ) --inplace eval-all '(.Prototypes.[] | select(."name" == "BattleButton")).components.UIDataLocalVarsComponent.data += (.dynamic_vars) | select(filename == "mod_$@.yaml") | ... comments = ""' mod_$@ effects.yaml
	$(foreach i_component,$(button_components),$(add_button_effects))
	$(CP) mod_$@ $(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/$@
