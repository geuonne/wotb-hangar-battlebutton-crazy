include ../definitions.mk
include ../yaml_definitions.mk

# Constants
c_mod_crazyeffects_file = effects.yaml
c_mod_placeholder_entry_file = placeholder_entry.yaml
c_mod_cloak_file = cloak.yaml
c_button_width = 344.0

mod_target_language = ru

# Space-separated list of button types
button_controls_battle = BattleWrapper TrainingButton CrazyPlaceholder
button_controls_squad = ReadyButton NotReadyButton BackToSquadButton

define TARGETS =
$(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/BattleButton.yaml $(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/SquadBattleButtonControls.yaml
endef

# default goal
.PHONY: all
all: $(TARGETS)

define BattleWrapper_control_setup =
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
endef

define TrainingButton_control_setup =
endef

define CrazyPlaceholder_control_setup =
$(eval _component = ($(call yq_dava,.Prototypes[]->BattleButton->ButtonWrapper->BattleButtonWrapper).children))
$(YQ) --inplace '$(_component) = load("$(c_mod_placeholder_entry_file)") + $(_component)' $@ $(_STASEP)
endef

define add_control_string_pool =
# Add variable where randomized quote is stored
$(eval _component = ($(base_control).components.UIDataLocalBindingsComponent.data))
$(eval _string_pool_var = [["string", "crazy_$(i_control)buttonText", "crazy_$(i_control)buttonStringPool[rand(Size(crazy_$(i_control)buttonStringPool))]"]] | ... style = "flow" | .[].[] style = "double")
$(YQ) --inplace '$(_component) += ($(_string_pool_var))' $@ $(_STASEP)

# Add string pool itself
# All entries
$(eval _component = ($(base_control).components.UIDataLocalVarsComponent.data))
$(eval all_entries = [.$(mod_target_language).$(i_control).*, .*.$(i_control).original, [.$(mod_target_language).* | select(has("original")).original[]], .any.$(i_control).*, .any.common.*, .$(mod_target_language).common.*])
# Placeholder button has its own set of entries
$(eval all_entries = $(if $(subst placeholder,,$(i_control)),$(all_entries),[.$(mod_target_language).$(i_control).*$(,) .any.$(i_control).*]))

$(eval string_pool != $(YQ) eval-all '$(all_entries) | flatten | ... comments = "" | unique | . style = "flow"' $^ | $(SED) 's/", "/"; "/g; s/\("@@\|@@"\)//g; s/\\\"/"/g; s/"/\\\"/g; s/\(.*\)/"\1"/')
$(eval _string_pool_formatted = [["vector<string>", "crazy_$(i_control)buttonStringPool", $(string_pool)]] | ... style = "flow" | .[].[] style = "double")
$(YQ) --inplace '$(_component) += ($(_string_pool_formatted))' $@ $(_STASEP)
endef

define add_textcomponent_binding =
$(eval _component = ($(call yq_dava,$(base_control).children[]$(if $(filter $(i_control),$(button_controls_squad)),,->ButtonWrapper->BattleButtonWrapper)->$(i_control)->Content->Text)))
$(eval _data = ({"bindings": [["UITextComponent.text", "crazy_$(i_control)buttonText"]]} | .. style = "double" | .[].[] style = "flow"))
$(YQ) --inplace '$(_component) += $(_data)' $@ $(_STASEP)
endef

define add_control_crazyeffects =
# Add effect bindings
$(eval _component = ($(call yq_dava,$(base_control).children[]$(if $(filter $(i_control),$(button_controls_squad)),,->ButtonWrapper->BattleButtonWrapper)->$(i_control))).bindings)
$(eval _command = $(YQ) --inplace '$(_component) += (load("$(c_mod_crazyeffects_file)").bindings)' $@ $(_STASEP))
$(if $(filter $(i_control),CrazyPlaceholder),$(eval _command = ))
$(_command)
endef


define ReadyButton_control_setup =
$(eval _component = ($(call yq_dava,$(base_control).children[]->ReadyButtonWrapper->$(i_control)->Content->Text)))
$(eval _data = ({"bindings": [["UITextComponent.text", "crazy_$(i_control)buttonText"]]} | .. style = "double" | .[].[] style = "flow"))
$(YQ) --inplace '$(_component) += $(_data)' $@ $(_STASEP)

$(eval _component = ($(call yq_dava,$(base_control).children[]->ReadyButtonWrapper->$(i_control))).bindings)
$(YQ) --inplace '$(_component) += (load("$(c_mod_crazyeffects_file)").bindings)' $@ $(_STASEP)

$(eval _component = ($(call yq_dava,$(base_control).children[]->ReadyButtonWrapper->$(i_control)->Content)))
$(eval _component_element = $(_component).components.SizePolicy.horizontalValue)
$(eval _data = $(c_button_width))
$(YQ) --inplace '$(_component_element) = $(_data)' $@ $(_STASEP)
endef

define NotReadyButton_control_setup =
$(eval _component = ($(call yq_dava,$(base_control).children[]->$(i_control)->Content)))
$(eval _component_element = $(_component).components.SizePolicy.horizontalValue)
$(eval _data = $(c_button_width))
$(YQ) --inplace '$(_component_element) = $(_data)' $@ $(_STASEP)
endef

define BackToSquadButton_control_setup =
$(eval _component = ($(call yq_dava,$(base_control).children[]->$(i_control)->Content)))
$(eval _component_element = $(_component).components.SizePolicy.horizontalValue)
$(eval _data = $(c_button_width))
$(YQ) --inplace '$(_component_element) = $(_data)' $@ $(_STASEP)
endef

$(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/BattleButton.yaml: base_control = $(call yq_dava,.Prototypes[]->BattleButton)
$(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/BattleButton.yaml: button_controls = $(button_controls_battle)

$(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/SquadBattleButtonControls.yaml: base_control = $(call yq_dava,.Prototypes[]->SquadControlsWrapper)
$(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/SquadBattleButtonControls.yaml: button_controls = $(button_controls_squad)

$(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/BattleButton.yaml $(PROJECTROOT)/$(SRCDIR)/UI/Screens3/Lobby/Hangar/SquadBattleButtonControls.yaml: button_entries/button_entries_*.yaml
	$(CP) $(@F) $@
	$(foreach i_control,$(button_controls),$($(i_control)_control_setup))
#	Add needed dynamic variables for button entries
	$(YQ) --inplace eval-all '($(base_control).components.UIDataLocalVarsComponent.data) += [.any.dynamic_vars[], .$(mod_target_language).dynamic_vars[]] | select(filename == "$@")' $@ $^
	$(foreach i_control,$(button_controls),$(add_control_string_pool))
#	Add crazy_effect variables
	$(YQ) --inplace '($(base_control).components.UIDataLocalVarsComponent.data) += (load("$(c_mod_crazyeffects_file)").dynamic_vars)' $@
	$(foreach i_control,$(button_controls),$(add_textcomponent_binding))
	$(foreach i_control,$(button_controls),$(add_control_crazyeffects))
	$(YQ) --inplace '... comments = ""' $@

.PHONY: clean
clean:
	$(RM) -r -f $(TARGETS)
