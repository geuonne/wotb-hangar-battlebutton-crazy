include ../definitions.mk

# Constants
c_mod_effects_file = effects.yaml
c_mod_placeholder_entry_file = placeholder_entry.yaml
c_mod_cloak_file = cloak.yaml
c_button_width = 344.0

mod_target_language = ru

# Space-separated list of button types
button_types = battle training placeholder
button_components = BattleWrapper TrainingButton

define battle_button_setup =
# Delete original buttonText variable first as duplicates are not allowed
$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton).components.UIDataLocalBindingsComponent.data))
$(YQ) --inplace 'del($(_component).[] | select(.[1] == "buttonText"))' $@ $(_STASEP)

# Set button width
$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton->ButtonWrapper->BattleButtonWrapper->BattleWrapper)))
$(eval _component_element = $(_component).components.SizePolicy.horizontalValue)
$(eval _data = $(c_button_width))
$(YQ) --inplace '$(_component_element) = $(_data)' $@ $(_STASEP)

$(eval _component_element = ($(call yq_dava,$(_component).children[]->Content->ActiveBg).components.Background.drawType))
$(eval _data = "DRAW_SCALE_TO_RECT")
$(YQ) --inplace '$(_component_element) = ($(_data))' $@ $(_STASEP)

$(eval _component_element = ($(call yq_dava,$(_component).children[]->battle_top).position[0]))
$(eval _data = $(c_button_width) / 2$(_YQ_forcefloat))
$(YQ) --inplace '$(_component_element) = ($(_data))' $@ $(_STASEP)

$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton->ButtonWrapper->BattleButtonWrapper->BattleTypeWrapper)))
$(YQ) --inplace '$(_component) += {"bindings": load("$(c_mod_cloak_file)").bindings_battleType}' $@ $(_STASEP)

$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton->ButtonWrapper->BattleButtonWrapper->Shadows)))
$(YQ) --inplace '$(_component) += {"bindings": load("$(c_mod_cloak_file)").bindings}' $@ $(_STASEP)
endef

define training_button_setup =
# Rebind training button text to the randomized string variable
$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton->ButtonWrapper->BattleButtonWrapper->TrainingButton->Content->Text)))
$(eval _data = ({"bindings": [["UITextComponent.text", "$(i_element)buttonText"]]} | .. style = "double" | .[].[] style = "flow"))
$(YQ) --inplace '$(_component) += $(_data)' $@ $(_STASEP)
endef

define placeholder_button_setup =
$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton->ButtonWrapper->BattleButtonWrapper).children))
$(YQ) --inplace '$(_component) = load("$(c_mod_placeholder_entry_file)") + $(_component)' $@ $(_STASEP)
endef

define add_control_string_pool =
# Add variable where randomized quote is stored
$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton)).components.UIDataLocalBindingsComponent.data)
# Label of battle button is named buttonText, not battleButtonText
$(eval _i_element = $(subst battle,,$(i_element)))
$(eval _string_pool_var = [["string", "$(_i_element)buttonText", "$(i_element)buttonStringPool[rand(Size($(i_element)buttonStringPool))]"]]  .[].[] style = "flow" | ... style = "flow")
$(YQ) --inplace '$(_component) += ($(_string_pool_var))' $@ $(_STASEP)

# Add string pool itself
# All entries
$(eval _component = ($(call yq_dava,.Prototypes.[]->BattleButton)).components.UIDataLocalVarsComponent.data)
$(eval all_entries = [.$(mod_target_language).$(i_element).*, .*.$(i_element).original, [.$(mod_target_language).* | select(has("original")).original[]], .any.$(i_element).*, .any.common.*, .$(mod_target_language).common.*])
# Placeholder button has its own set of entries
$(eval all_entries = $(if $(subst placeholder,,$(i_element)),$(all_entries),[.$(mod_target_language).$(i_element).*$(,) .any.$(i_element).*]))

$(eval string_pool != $(YQ) eval-all '$(all_entries) | flatten | ... comments = "" | unique | . style = "flow"' $^ | $(SED) 's/", "/"; "/g; s/\("@@\|@@"\)//g; s/\\\"/"/g; s/"/\\\"/g; s/\(.*\)/"\1"/')
$(eval _string_pool_formatted = [["vector<string>", "$(i_element)buttonStringPool", $(string_pool)]] | ... style = "flow" | .[].[] style = "double")
$(YQ) --inplace '$(_component) += ($(_string_pool_formatted))' $@ $(_STASEP)
endef

define add_button_effects =
# Add effect bindings
$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton->ButtonWrapper->BattleButtonWrapper->$(i_component))).bindings)
$(YQ) --inplace '$(_component) += load("$(c_mod_effects_file)").bindings' $@ $(_STASEP)
endef

$(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/BattleButton.yaml: button_entries/button_entries_*.yaml
	$(CP) $(@F) $@
	$(foreach i_element,$(button_types),$($(i_element)_button_setup))
#	Add dynamic variables for specified target language & common quotes
	$(YQ) --inplace eval-all '($(call yq_dava,.Prototypes[]->BattleButton).components.UIDataLocalVarsComponent.data) += [.any.dynamic_vars[], .$(mod_target_language).dynamic_vars[]] | select(filename == "$@")' $@ $^
	$(foreach i_element,$(button_types),$(add_control_string_pool))
#	Add effect variables
	$(YQ) --inplace '($(call yq_dava,.Prototypes[]->BattleButton)).components.UIDataLocalVarsComponent.data += (load("$(c_mod_effects_file)").dynamic_vars)' $@
	$(foreach i_component,$(button_components),$(add_button_effects))
	$(YQ) --inplace '... comments = ""' $@

all: $(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/BattleButton.yaml
