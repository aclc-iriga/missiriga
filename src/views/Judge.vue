<template>
    <top-nav ref="top-nav" @toggle-help="handleToggleHelp" @sign-out="handleSignOut"/>

    <side-nav/>

	<!--	Judge Score Sheet	-->
	<v-main v-if="$store.getters['auth/getUser'] !== null">
		<v-table
			v-if="$route.params.eventSlug && event"
			density="comfortable"
			fixed-header
			:height="scoreSheetHeight"
		>
			<thead>
				<tr>
					<th
                        colspan="3"
                        class="text-uppercase text-center font-weight-bold text-grey-darken-4 py-3"
                        :class="$vuetify.display.mdAndDown ? 'text-h5' : 'text-h4'"
                    >
						{{ event.title }}
					</th>
					<th
						v-for="(criterion, criterionIndex) in criteria"
						style="width: 13%"
						class="text-center text-uppercase py-3"
						:class="{ 'bg-grey-lighten-4': coordinates.x == criterionIndex && !scoreSheetDisabled }"
					>
						<div class="d-flex h-100 flex-column align-content-space-between">
                            <p
                                class="text-grey-darken-1"
                                :class="{
                                    'text-caption text-uppercase': $vuetify.display.mdAndDown,
                                    'text-grey-darken-3': coordinates.x == criterionIndex && !scoreSheetDisabled
                                }"
                            >
                                {{ criterion.title }}
                            </p>
                            <b
                                class="text-grey-darken-2 text-h6 pt-1"
                                :class="{
                                    'text-body-2 text-uppercase font-weight-bold': $vuetify.display.mdAndDown,
                                    'text-grey-darken-4': coordinates.x == criterionIndex && !scoreSheetDisabled
                                }"
                                style="margin-top: auto"
                            >
                                {{ criterion.percentage }}%
                            </b>
						</div>
					</th>
					<th
						style="width: 13%"
						class="text-uppercase text-center text-grey-darken-3 font-weight-bold py-3"
						:class="{ 'bg-grey-lighten-4': coordinates.x == criteria.length && !scoreSheetDisabled }, $vuetify.display.mdAndDown ? 'text-body-1' : 'text-h6'"
					>
						Total
                        <p class="ma-0 text-subtitle-2 text-green-darken-2">{{ minRating.toFixed(2) }} - {{ (maxRating >= 100) ? maxRating.toFixed(0) : maxRating.toFixed(2) }}</p>
					</th>
					<th
						style="width: 13%"
						class="text-uppercase text-center text-grey-darken-3 font-weight-bold py-3"
                        :class="$vuetify.display.mdAndDown ? 'text-body-1' : 'text-h6'"
					>
						Rank
                        <p class="ma-0 text-subtitle-2" :class="{ 'text-success': tiesTotal <= 0, 'text-warning': tiesTotal > 0 }">
                            (<b v-if="tiesTotal > 0">{{ tiesTotal }}</b><span v-else>NO</span> TIE<template v-if="tiesTotal > 1">S</template>)
                        </p>
					</th>
                    <th>
                        <!-- Tie Breaker Dialog -->
                        <v-dialog
                            v-model="tieBreaker.opened"
                            max-width="1024"
                            scrollable
                        >
                            <template #activator="{ props }">
                                <v-btn @click="openTieBreaker" v-bind="props" variant="outlined" color="warning" density="compact" :disabled="tiesTotal <= 0 || scoreSheetDisabled"
                                    style=" white-space: normal; overflow: visible; height: auto; padding-top: 8px; padding-bottom: 8px;"
                                >
                                    <span class="d-flex flex-column"><span><v-icon>mdi-open-in-new</v-icon> Tie</span><span>Breaker</span>
                                    </span>
                                </v-btn>
                            </template>
                            <v-card>
                                <v-card-title>
                                    <div class="d-flex justify-space-between align-center">
                                        <span class="text-warning">Tie Breaker</span>
                                        <v-btn icon variant="text" color="warning" @click="closeTieBreaker"><v-icon>mdi-close</v-icon></v-btn>
                                    </div>
                                </v-card-title>
                                <v-divider/>
                                <v-card-text>
                                    <v-sheet
                                        v-for="(tieGroup, tieGroupKey, tieGroupIndex) in tieBreaker.tieGroups"
                                        :key="tieGroupKey"
                                    >
                                        <v-row no-gutters>
                                            <v-col cols="12" sm="5" md="5" lg="5" class="text-center text-sm-left">
                                                <div class="pb-3">
                                                    <h2>Ties at Rank {{ tieGroupKey.replace('rank_', '') }}</h2>
                                                </div>
                                            </v-col>
                                            <v-col cols="12" sm="7" md="7" lg="7" class="text-center text-sm-left" :style="tieGroup.result.length > 0 ? 'border-bottom: 1px solid #ddd;' : ''">
                                                <div class="pb-3">
                                                    <h2>Assign to Slots: Rank {{ tieGroup.slots[0] }} <v-icon>mdi-arrow-right</v-icon> Rank {{ tieGroup.slots[tieGroup.slots.length - 1] }}</h2>
                                                </div>
                                            </v-col>
                                        </v-row>
                                        <v-row no-gutters>
                                            <!-- Tie Breaker :: Ties -->
                                            <v-col cols="10" sm="4" md="4" lg="4">
                                                <draggable
                                                    :style="`min-height: ${tieGroup.slots.length * 76}px; height: 100%; cursor: grab`"
                                                    :list="tieGroup.teams"
                                                    :group="tieGroupKey"
                                                    itemKey="id"
                                                >
                                                    <template #item="{ element, index }">
                                                        <div class="d-flex align-center py-1" style="height: 76px; column-gap: 8px;">
                                                            <div class="drag-handle flex-grow-0 flex-shrink-0" style="width: 24px; cursor: grab; display: flex; align-items: center; justify-content: center;">
                                                                <v-icon small>mdi-drag-vertical</v-icon>
                                                            </div>
                                                            <div class="text-center flex-grow-0 flex-shrink-0" style="width: 32px;">
                                                                <h2 class="ma-0">{{ element.number }}</h2>
                                                            </div>
                                                            <v-avatar class="flex-grow-0 flex-shrink-0" size="60">
                                                                <v-img cover :src="`${$store.getters.appURL}/crud/uploads/${element.avatar}`" transition="none" eager/>
                                                            </v-avatar>
                                                            <div class="overflow-hidden">
                                                                <p class="mt-0 me-0 mb-1 ms-0 text-subtitle-2 text-uppercase font-weight-bold" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; line-height: 1.2; width: 100%;">
                                                                    {{ element.name }}
                                                                </p>
                                                                <p class="mb-0" v-if="element.location.trim() !== ''" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; line-height: 1; opacity: 0.8; width: 100%;">
                                                                    <small><b>{{ element.location }}</b></small>
                                                                </p>
                                                                <p class="mb-0" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; line-height: 1; opacity: 0.85; width: 100%;">
                                                                    <small style="font-size: 13px">for <b>{{ element.competing_for }}</b></small>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </template>
                                                </draggable>
                                            </v-col>

                                            <!-- Tie Breaker :: Ties Action -->
                                            <v-col cols="2" sm="1" md="1" lg="1">
                                                <div
                                                    v-for="(tieGroupTeam, tieGroupTeamIndex) in tieGroup.teams"
                                                    :key="tieGroupTeam.id"
                                                    class="d-flex justify-start align-center"
                                                    style="height: 76px; padding-left: 8px; column-gap: 8px;"
                                                >
                                                    <v-btn icon density="comfortable" color="warning" elevation="0" @click="toRightTieBreaker(tieGroupKey, tieGroupTeamIndex)">
                                                        <v-icon>mdi-arrow-right</v-icon>
                                                    </v-btn>
                                                </div>
                                            </v-col>

                                            <!-- Tie Breaker :: Slot Label -->
                                            <v-col cols="2" sm="1" md="1" lg="1">
                                                <div v-for="(slot, slotIndex) in tieGroup.slots" :key="slot">
                                                    <div
                                                        class="d-flex justify-center align-center text-center"
                                                        style="height: 76px; border-bottom: 1px solid #ddd; border-left: 1px solid #ddd"
                                                        :style="{ 'border-top': (slotIndex === 0 && tieGroup.result.length <= 0) ? '1px solid #ddd' : '0' }"
                                                    >
                                                        <h4 class="ma-0 text-success" :style="{ 'opacity': tieGroup.result[slotIndex] ? '1' : '0.55' }"><span style="font-size: 1.1rem;">R</span>ank <span style="font-size: 1.2rem;">{{ slot }}</span></h4>
                                                    </div>
                                                </div>
                                            </v-col>

                                            <!-- Tie Breaker :: Slots -->
                                            <v-col cols="6" sm="4" md="4" lg="4">
                                                <draggable
                                                    :style="`min-height: ${tieGroup.slots.length * 76}px; height: 100%; cursor: grab;`"
                                                    :list="tieGroup.result"
                                                    :group="tieGroupKey"
                                                    itemKey="id"
                                                >
                                                    <template #item="{ element, index }">
                                                        <div class="d-flex align-center py-1" style="height: 76px; column-gap: 8px; border-bottom: 1px solid #ddd;">
                                                            <div class="drag-handle flex-grow-0 flex-shrink-0" style="width: 24px; cursor: grab; display: flex; align-items: center; justify-content: center;">
                                                                <v-icon small>mdi-drag-vertical</v-icon>
                                                            </div>
                                                            <div class="text-center flex-grow-0 flex-shrink-0" style="width: 32px;">
                                                                <h2 class="ma-0">{{ element.number }}</h2>
                                                            </div>
                                                            <v-avatar class="flex-grow-0 flex-shrink-0" size="60">
                                                                <v-img cover :src="`${$store.getters.appURL}/crud/uploads/${element.avatar}`" transition="none" eager/>
                                                            </v-avatar>
                                                            <div class="overflow-hidden">
                                                                <p class="mt-0 me-0 mb-1 ms-0 text-subtitle-2 text-uppercase font-weight-bold" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; line-height: 1.2; width: 100%;">
                                                                    {{ element.name }}
                                                                </p>
                                                                <p class="mb-0" v-if="element.location.trim() !== ''" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; line-height: 1; opacity: 0.8; width: 100%;">
                                                                    <small><b>{{ element.location }}</b></small>
                                                                </p>
                                                                <p class="mb-0" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; line-height: 1; opacity: 0.85; width: 100%;">
                                                                    <small style="font-size: 13px;">for <b>{{ element.competing_for }}</b></small>
                                                                </p>
                                                            </div>
                                                        </div>
                                                    </template>
                                                </draggable>
                                            </v-col>

                                            <!-- Tie Breaker :: Slot Actions -->
                                            <v-col cols="4" sm="2" md="2" lg="2">
                                                <div
                                                    v-for="(tieGroupResult, tieGroupResultIndex) in tieGroup.result"
                                                    :key="tieGroupResult.id"
                                                    class="d-flex justify-end align-center"
                                                    style="height: 76px; padding-right: 8px; column-gap: 8px; border-bottom: 1px solid #ddd; border-right: 1px solid #ddd"
                                                >
                                                    <v-btn icon density="comfortable" color="success" elevation="0" variant="text" @click="sortUpTieBreaker(tieGroupKey, tieGroupResultIndex)" :disabled="tieGroupResultIndex <= 0">
                                                        <v-icon>mdi-arrow-up</v-icon>
                                                    </v-btn>
                                                    <v-btn icon density="comfortable" color="success" elevation="0" variant="text" @click="sortDownBreaker(tieGroupKey, tieGroupResultIndex)" :disabled="tieGroupResultIndex >= (tieGroup.result.length - 1)">
                                                        <v-icon>mdi-arrow-down</v-icon>
                                                    </v-btn>
                                                    <v-btn icon density="comfortable" color="error" elevation="0" variant="text" @click="toLeftTieBreaker(tieGroupKey, tieGroupResultIndex)">
                                                        <v-icon>mdi-close</v-icon>
                                                    </v-btn>
                                                </div>
                                            </v-col>
                                        </v-row>
                                        <v-divider class="my-10" v-if="tieGroupIndex < (Object.keys(tieBreaker.tieGroups).length - 1)"/>
                                    </v-sheet>
                                </v-card-text>
                                <v-card-actions>
                                    <v-spacer />
                                    <v-btn text @click="closeTieBreaker" size="large">Close</v-btn>
                                    <v-btn variant="flat" color="warning" @click="applyTieBreaker" size="large" :disabled="tieBreaker.loading">Confirm Slots</v-btn>
                                </v-card-actions>
                            </v-card>
                        </v-dialog>
                    </th>
				</tr>
			</thead>
			<tbody>
				<tr
					v-for="(team, teamIndex) in teams"
					:key="team.id"
                    :id="`row--team-${team.id}`"
					:class="{ 'bg-grey-lighten-4': coordinates.y == teamIndex && !scoreSheetDisabled }"
				>
                    <td
                        class="text-uppercase text-right text-h5 font-weight-bold text-grey-darken-2"
                        :class="{ 'text-grey-darken-4': coordinates.y == teamIndex && !scoreSheetDisabled }"
                    >
                        {{ team.number }}
                    </td>
                    <td style="width: 72px;">
                        <v-avatar size="72" class="avatar" style="cursor: pointer;" :style="{ 'opacity' : (coordinates.y == teamIndex && !scoreSheetDisabled) ? '1' : '0.9' }">
                            <v-img class="avatar-hover-effect" cover :src="`${$store.getters.appURL}/crud/uploads/${team.avatar}`" transition="none" eager>
                                <v-tooltip activator="parent" location="left" align="center">
                                    <v-card
                                        class="mx-auto"
                                        theme="dark"
                                    >
                                        <v-img
                                            height="400"
                                            width="280"
                                            :lazy-src="`${$store.getters.appURL}/crud/uploads/full/${team.avatar}`"
                                            :src="`${$store.getters.appURL}/crud/uploads/full/${team.avatar}`"
                                            cover
                                        >
                                            <template v-slot:placeholder>
                                                <div class="d-flex align-center justify-center fill-height">
                                                    <v-progress-circular
                                                        color="grey-lighten-4"
                                                        indeterminate
                                                    ></v-progress-circular>
                                                </div>
                                            </template>
                                        </v-img>
                                    </v-card>
                                </v-tooltip>
                            </v-img>
                        </v-avatar>
                    </td>
                    <td
                        class="px-0 text-grey-darken-2"
                        :class="{ 'text-grey-darken-4': coordinates.y == teamIndex && !scoreSheetDisabled }"
                    >
                        <p class="ma-0 text-subtitle-2 text-uppercase font-weight-bold" style="line-height: 1.2">{{ team.name }}</p>
                        <p class="mt-1 mb-0" style="line-height: 1"><small>{{ team.location }}</small></p>
                        <p class="mt-1 mb-0 opacity-50" style="line-height: 1; font-size: 14px"><small>for <b>{{ team.competing_for }}</b></small></p>
                    </td>
					<td
						v-for="(criterion, criterionIndex) in criteria"
						:key="criterion.id"
						:class="{ 'bg-grey-lighten-4': coordinates.x == criterionIndex && !scoreSheetDisabled }"
					>
                        <!-- Criteria Rating (Note: opted for type="text" because of caret-focus issue on backspace inside type="number") -->
						<v-text-field
							type="text"
                            inputmode="decimal"
							class="font-weight-bold text-center"
							hide-details
							single-line
							:min="0"
							:max="criterion.percentage"
							@change="saveRating(ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`], criterion.percentage, team)"
							v-model.number="ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value"
							:class="{
								'text-error font-weight-bold': (
									ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value < 0 ||
									ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value > criterion.percentage
								),
								'text-grey-darken-1': ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value === 0,
								'text-grey-darken-3': (
                                    ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value > 0 &&
                                    ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value <= criterion.percentage
                                )
							}"
							:error="(
								  ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value.toString().trim() === ''
							   || ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value < 0
							   || ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value > criterion.percentage
							)"
                            :variant="
                                ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value < 0
                                ||
                                ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value > criterion.percentage
                                ? 'outlined' : 'underlined'
							"
							:disabled="team.disabled || ratings[`${event.slug}_${team.id}`][`${$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].is_locked"
							:id="`input_${teamIndex}_${criterionIndex}`"
                            @keyup.prevent="handleRatingKeyUp(team)"
                            @keydown.down.prevent="moveDown(criterionIndex, teamIndex)"
							@keydown.enter="moveDown(criterionIndex, teamIndex)"
							@keydown.up.prevent="moveUp(criterionIndex, teamIndex)"
							@keydown.right.prevent="moveRight(criterionIndex, teamIndex)"
							@keydown.left.prevent="moveLeft(criterionIndex, teamIndex)"
							@focus.passive="updateCoordinates(criterionIndex, teamIndex)"
                            @keydown="e => {
                                const navKeys = ['Backspace','Tab','ArrowLeft','ArrowRight','Delete']
                                if (navKeys.includes(e.key)) return;
                                if (e.ctrlKey || e.metaKey) return;
                                if (e.key === '.' && e.target.value.includes('.')) { e.preventDefault(); return; }
                                if (!/[0-9.]/.test(e.key)) { e.preventDefault(); }
                            }"
                            @paste="e => {
                                const text = (e.clipboardData || window.clipboardData).getData('text');
                                if (!/^[0-9]*\.?[0-9]*$/.test(text)) { e.preventDefault() }
                            }"
						/>
					</td>
					<td :class="{ 'bg-grey-lighten-4': coordinates.x == criteria.length && !scoreSheetDisabled }">
                        <!-- Total Rating (Note: opted for type="text" because of caret-focus issue on backspace inside type="number") -->
						<v-text-field
							type="text"
                            inputmode="decimal"
							class="font-weight-bold text-center"
                            variant="outlined"
                            hide-details
							:loading="totals[`team_${team.id}`].loading"
							v-model.number="totals[`team_${team.id}`].value"
							:min="minRating"
							:max="maxRating"
							@change="calculateTotalScores(team)"
                            :ref="`txt-total-${team.id}`"
							:class="{
                                'text-error font-weight-bold'  : totalErrors[`team_${team.id}`].invalid,
                                'text-success font-weight-bold': !totalErrors[`team_${team.id}`].invalid,
                                'v-input-total-error': !totalErrors[`team_${team.id}`].empty && totalErrors[`team_${team.id}`].invalid
							}"
                            :error="totalErrors[`team_${team.id}`].empty || totalErrors[`team_${team.id}`].invalid"
                            :label="(
                                (!totalErrors[`team_${team.id}`].empty && totalErrors[`team_${team.id}`].invalid)
                                ? `${minRating} - ${maxRating}` : ''
                            )"
							:disabled="team.disabled || totals[`team_${team.id}`].is_locked"
							:id="`input_${teamIndex}_${criteria.length}`"
							@keydown.down.prevent="moveDown(criteria.length, teamIndex)"
							@keydown.enter="moveDown(criteria.length, teamIndex)"
							@keydown.up.prevent="moveUp(criteria.length, teamIndex)"
							@keydown.right.prevent="moveRight(criteria.length, teamIndex)"
							@keydown.left.prevent="moveLeft(criteria.length, teamIndex)"
							@focus.passive="updateCoordinates(criteria.length, teamIndex)"
                            @keydown="e => {
                                const navKeys = ['Backspace','Tab','ArrowLeft','ArrowRight','Delete']
                                if (navKeys.includes(e.key)) return;
                                if (e.ctrlKey || e.metaKey) return;
                                if (e.key === '.' && e.target.value.includes('.')) { e.preventDefault(); return; }
                                if (!/[0-9.]/.test(e.key)) { e.preventDefault(); }
                            }"
                            @paste="e => {
                                const text = (e.clipboardData || window.clipboardData).getData('text');
                                if (!/^[0-9]*\.?[0-9]*$/.test(text)) { e.preventDefault() }
                            }"
						/>
					</td>
                    <td
                        class="text-center font-weight-bold pa-0"
                        :class="{
                            'text-grey-darken-2': coordinates.y != teamIndex && !scoreSheetDisabled,
                            'text-grey-darken-4': coordinates.y == teamIndex && !scoreSheetDisabled,
                            'text-grey-darken-1': scoreSheetDisabled,
                        }"
                    >
                        <h4 class="ma-0" style="font-size: 1.1rem;" :style="{'opacity': team.disabled ? 0.6 : 1}">{{ ranks[`team_${team.id}`] }}</h4>
                    </td>
                    <td class="pa-0 text-center">
                        <template v-if="`team_${team.id}` in ties">
                            <v-tooltip location="top" :content-class="'transparent-tooltip'">
                                <template #activator="{ props }">
                                    <svg
                                        v-bind="props"
                                        width="12"
                                        height="12"
                                        xmlns="http://www.w3.org/2000/svg"
                                        style="cursor: pointer; opacity: 0.7"
                                    >
                                        <circle cx="6" cy="6" r="6" :fill="ties[`team_${team.id}`].color" />
                                    </svg>
                                </template>
                                <span
                                    style="color: white; padding: 4px 8px; border-radius: 4px; display: inline-block; opacity: 0.7"
                                    :style="{ 'background-color': ties[`team_${team.id}`].color }"
                                >
                                    {{ ties[`team_${team.id}`].tooltip }}
                                </span>
                            </v-tooltip>
                        </template>
                        <svg v-else width="12" height="12" xmlns="http://www.w3.org/2000/svg" style="visibility: hidden">
                            <circle cx="6" cy="6" r="6" fill="#FF0000" />
                        </svg>
                    </td>
                </tr>
			</tbody>
			<!--	Dialog	  -->
			<tfoot>
                <tr>
                    <td colspan="12">
                        <v-col align="center"
                               justify="end"
                        >
                            <v-btn
                                class="py-7 bg-grey-lighten-1 text-grey-darken-3"
                                @click="openSubmitDialog"
                                :disabled="scoreSheetDisabled"
                                block
                                flat
                            >
                            <p style="font-size: 1.2rem;">submit ratings</p>
                            </v-btn>
                            <v-dialog
                                v-model="submitDialog"
                                :persistent="submitLoading"
                                max-width="800"
                                class="overflow-hidden"
                            >
                                <v-card>
                                    <v-card-title class="bg-black">
                                        <div class="d-flex justify-space-between align-center">
                                            <span><v-icon id="remind">mdi-information</v-icon> Submit Ratings for {{ event.title }}</span>
                                            <v-btn icon variant="text" color="white" density="comfortable" :disabled="submitLoading" @click="submitDialog = false"><v-icon>mdi-close</v-icon></v-btn>
                                        </div>
                                    </v-card-title>
                                    <v-card-text class="px-0 pt-0">
                                        <v-table density="compact" :height="$store.getters['windowHeight'] - 320" fixed-header fixed-footer hover>
                                            <thead>
                                            <tr>
                                                <th></th>
                                                <th class="text-left text-uppercase">Candidate</th>
                                                <th class="text-center text-uppercase">Rating</th>
                                                <th class="text-center text-uppercase">Rank</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr
                                                v-for="(team, index) in sortedTeams"
                                                :key="team.id"
                                            >
                                                <td class="text-right py-2 pr-2" style="width: 60px"><h3 class="ma-0">{{ team.number }}</h3></td>
                                                <td class="py-2">
                                                    <div style="display: flex; align-items: center; gap: 12px; line-height: 1.2;">
                                                        <v-avatar size="50">
                                                            <v-img :src="`${$store.getters.appURL}/crud/uploads/${team.avatar}`" cover/>
                                                        </v-avatar>
                                                        <div>
                                                            <p class="ma-0 text-subtitle-2 text-uppercase font-weight-bold">{{ team.name }}</p>
                                                            <p class="ma-0"><small>{{ team.location }}</small></p>
                                                            <p class="ma-0 opacity-50" style="font-size: 14px"><small>for <b>{{ team.competing_for }}</b></small></p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="text-center py-2 text-dark">{{ totals[`team_${team.id}`].value.toFixed(2) }}</td>
                                                <td class="text-center py-2 text-dark">{{ ranks[`team_${team.id}`] }}</td>
                                            </tr>
                                            </tbody>
                                            <tfoot>
                                            <tr>
                                                <td colspan="5" class="bg-white" v-if="sortedTeams.length > 0">
                                                    <p class="mt-5" style="line-height: 1.6">
                                                        Please review your ratings and ranks for <b>{{ event.title }}</b>, then submit when you're ready.
                                                        <template v-if="tiesTotal > 1">You can also open the <a @click.prevent="openTieBreaker" class="text-warning font-weight-medium" style="cursor: pointer">Tie Breaker</a> if you'd like to resolve ties first.</template>
                                                    </p>
                                                </td>
                                            </tr>
                                            </tfoot>
                                        </v-table>
                                    </v-card-text>
                                    <v-card-actions class="pt-0">
                                        <v-spacer></v-spacer>
                                        <v-btn
                                            class="text-red-darken-1"
                                            :disabled="submitLoading"
                                            @click="submitDialog = false"
                                            size="large"
                                            height="50"
                                        >
                                            Go Back
                                        </v-btn>
                                        <v-btn
                                            class="text-green-darken-1"
                                            :loading="submitLoading"
                                            @click="submitRatings"
                                            size="large"
                                            height="50"
                                        >
                                            Submit
                                        </v-btn>
                                    </v-card-actions>
                                </v-card>
                            </v-dialog>
                            <v-dialog
                                v-if="inspectDialog"
                                v-model="inspectDialog"
                                persistent
                                max-width="400"
                            >
                                <v-card>
                                    <v-card-title class="bg-red-darken-4">
                                        <v-icon id="warning">mdi-alert</v-icon>	Submit Ratings
                                    </v-card-title>
                                    <v-card-text>
                                        <p class="mb-2 text-red-darken-4">
                                            Sorry, your ratings for <b>{{ event.title }}</b> cannot be submitted as they must be from
                                            <big><b>{{ minRating }}</b></big> to <big><b>{{ maxRating }}</b></big>.
                                        </p>
                                        <p class="text-red-darken-4">Please adjust your ratings and try submitting again.</p>
                                    </v-card-text>
                                    <v-card-actions>
                                        <v-spacer></v-spacer>
                                        <v-btn color="red-darken-4" @click="closeInspectDialog">Go Back</v-btn>
                                    </v-card-actions>
                                </v-card>
                            </v-dialog>
                        </v-col>
                    </td>
                </tr>
			</tfoot>
		</v-table>

		<!-- loader -->
		<div v-else-if="this.$route.params.eventSlug" class="d-flex justify-center align-center" style="height: 100vh;">
			<v-progress-circular
				:size="80"
				color="black"
				class="mb-16"
				indeterminate
			/>
		</div>
	</v-main>
</template>


<script>
    import topNav from '../components/nav/TopNav.vue';
    import sideNav from '../components/nav/SideNav.vue';
    import $ from 'jquery';
    import draggableComponent from 'vuedraggable';

    export default {
        name: 'Judge',
        emits: ['startPing'],
        components: {
            topNav,
            sideNav,
            draggable: draggableComponent
        },
        data() {
            return {
                dialog: false,
                submitDialog: false,
                submitLoading: false,
                inspectDialog: false,
                event: null,
                timer: null,
                teams: [],
                criteria: [],
                ratings: {},
                totals: {},
                coordinates: {
                    x: -1,
                    y: -1
                },
                tieBreaker: {
                    opened   : false,
                    loading  : false,
                    tieGroups: {}
                },
                competition: '',
                ws: null
            }
        },
        computed: {
            teamsAssoc() {
                const teams = {};
                for (let i = 0; i < this.teams.length; i++) {
                    teams[`team_${this.teams[i].id}`] = this.teams[i];
                }

                return teams;
            },
            ranks() {
                const teamRanks = {};

                // get unique totals
                const uniqueTotals = [];
                for (let i = 0; i < this.teams.length; i++) {
                    const team = this.teams[i];
                    const teamKey = `team_${team.id}`;
                    const total = this.totals[teamKey].value;
                    if (!uniqueTotals.includes(total))
                        uniqueTotals.push(total);

                    // push to teamRanks
                    teamRanks[teamKey] = 0;
                }

                // sort uniqueTotals in descending order
                uniqueTotals.sort((a, b) => b - a);

                // prepare rankGroup
                const rankGroup = {};

                // get dense rank of each team
                const denseRanks = {};
                for (let i = 0; i < this.teams.length; i++) {
                    const team = this.teams[i];
                    const teamKey = `team_${team.id}`;
                    const total = this.totals[teamKey].value;
                    const denseRank = 1 + uniqueTotals.indexOf(total);
                    denseRanks[denseRank] = denseRank;

                    // push to rankGroup
                    const rankGroupKey = `rank_${denseRank}`;
                    if (!rankGroup[rankGroupKey])
                        rankGroup[rankGroupKey] = [];
                    rankGroup[rankGroupKey].push(teamKey);
                }

                // get fractional rank
                let ctr = 0;
                for (let i = 0; i < uniqueTotals.length; i++) {
                    const key = `rank_${(i + 1)}`;
                    const group = rankGroup[key];
                    const size = group.length;
                    const fractionalRank = ctr + (((size * (size + 1)) / 2) / size);

                    // write fractionalRank to group members
                    for (let j = 0; j < size; j++) {
                        teamRanks[group[j]] = fractionalRank;
                    }
                    ctr += size;
                }
                return teamRanks;
            },
            tieGroups() {
                // raw groups
                const raw = {};
                for (const teamKey in this.ranks) {
                    const rank = this.ranks[teamKey];
                    const key = `rank_${rank}`;
                    if (!raw[key]) raw[key] = [];
                    raw[key].push(teamKey);
                }
                // sort the entries by the number after "rank_"
                const sortedEntries = Object.entries(raw).sort(
                    ([aKey], [bKey]) => {
                        const aNum = parseInt(aKey.split('_')[1], 10);
                        const bNum = parseInt(bKey.split('_')[1], 10);
                        return aNum - bNum;
                    }
                );
                // rebuild an object with insertion order = sorted order
                return Object.fromEntries(sortedEntries);
            },
            ties() {
                const ties = {};
                let ctr = -1;
                for(const rankKey in this.tieGroups) {
                    const rank = rankKey.replace('rank_', '');
                    ctr += 1;
                    const teamKeys = this.tieGroups[rankKey];
                    if (teamKeys.length > 1) {
                        for (let i = 0; i < teamKeys.length; i++) {
                            if (!(teamKeys[i] in ties)) {
                                ties[teamKeys[i]] = {
                                    rank   : rank,
                                    color  : this.primaryColors[ctr],
                                    equals : {
                                        teamKeys   : [],
                                        teamNumbers: [],
                                        phrase     : ''
                                    },
                                    tooltip: ''
                                }
                            }
                            for (let j = 0; j < teamKeys.length; j++) {
                                if (teamKeys[j] !== teamKeys[i]) {
                                    ties[teamKeys[i]].equals.teamKeys.push(teamKeys[j]);
                                    ties[teamKeys[i]].equals.teamNumbers.push(`#${this.teamsAssoc[teamKeys[j]].number}`);
                                }
                            }
                            // compute tooltip
                            ties[teamKeys[i]].equals.phrase = ties[teamKeys[i]].equals.teamNumbers.join(', ').replace(/, ([^,]*)$/, ' and $1');
                            ties[teamKeys[i]].tooltip = `Candidate #${this.teamsAssoc[teamKeys[i]].number} is TIE with Candidate${ties[teamKeys[i]].equals.teamKeys.length > 1 ? 's' : ''} ${ties[teamKeys[i]].equals.phrase} at RANK ${rank}.`
                        }
                    }
                }

                return ties;
            },
            tiesTotal() {
                return Object.keys(this.ties).length;
            },
            scoreSheetHeight() {
                return this.$store.getters.windowHeight - 64;
            },
            scoreSheetDisabled() {
                // initialize disable
                let disabled = true;
                // get ratings.is_locked and pass value to disabled variable
                for (let i = 0; i < this.teams.length; i++) {
                    const ratings = this.ratings[`${this.event.slug}_${this.teams[i].id}`];
                    for (let j = 0; j < this.criteria.length; j++) {
                        const criterion = this.criteria[j];
                        const rating = ratings[`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${this.teams[i].id}`]
                        if (!rating.is_locked) {
                            disabled = false;
                            break;
                        }
                    }
                }
                // return value
                return disabled;
            },
            totalCriteriaPercentage() {
                let percentage = 0;
                for(let i=0; i<this.criteria.length; i++) {
                    percentage += this.criteria[i].percentage;
                }
                return percentage;
            },
            minRating() {
                if(this.totalCriteriaPercentage >= 100)
                    return this.$store.state.rating.min;
                else
                    return this.totalCriteriaPercentage * 0.60;
            },
            maxRating() {
                if(this.totalCriteriaPercentage >= 100)
                    return this.$store.state.rating.max;
                else
                    return this.totalCriteriaPercentage;
            },
            totalErrors() {
                const errors = {};
                for(let i=0; i<this.teams.length; i++) {
                    const team  = this.teams[i];
                    const total = this.totals[`team_${team.id}`].value;
                    errors[`team_${team.id}`] = {
                        empty  : ['0', ''].includes(total.toString().trim()),
                        invalid: total < this.minRating || total > this.maxRating
                    };
                }
                return errors;
            },
            sortedTeams() {
                if (!this.submitDialog) {
                    return [];
                }

                return [...this.teams].sort((a, b) => {
                    const totalA = this.totals[`team_${a.id}`].value;
                    const totalB = this.totals[`team_${b.id}`].value;
                    return totalB - totalA;
                });
            },
            primaryColors() {
                const colors = [];
                const n = this.teams.length || 1;
                const GOLDEN_ANGLE = 137.508;

                // HSL to RGB
                const hslToRgb = (h, s, l) => {
                    h /= 360;
                    let r, g, b;
                    if (s === 0) {
                        r = g = b = l;
                    }
                    else {
                        const hue2rgb = (p, q, t) => {
                            if (t < 0) t += 1;
                            if (t > 1) t -= 1;
                            if (t < 1 / 6) return p + (q - p) * 6 * t;
                            if (t < 1 / 2) return q;
                            if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
                            return p;
                        };
                        const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
                        const p = 2 * l - q;
                        r = hue2rgb(p, q, h + 1 / 3);
                        g = hue2rgb(p, q, h);
                        b = hue2rgb(p, q, h - 1 / 3);
                    }
                    return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
                };

                // RGB to HEX
                const rgbToHex = (r, g, b) => {
                    const toHex = (x) => x.toString(16).padStart(2, "0");
                    return `#${toHex(r)}${toHex(g)}${toHex(b)}`.toUpperCase();
                };

                // contrast ratio for white (255,255,255)
                const getLuminance = (r, g, b) => {
                    const toLinear = (c) => {
                        c /= 255;
                        return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
                    };
                    const [R, G, B] = [toLinear(r), toLinear(g), toLinear(b)];
                    return 0.2126 * R + 0.7152 * G + 0.0722 * B;
                };

                const contrastWithWhite = (r, g, b) => {
                    const lum1 = getLuminance(r, g, b);
                    const lum2 = 1; // white
                    return (lum2 + 0.05) / (lum1 + 0.05); // must be >= 4.5 for normal text
                };

                for (let i = 0; i < n; i++) {
                    const hue = (i * GOLDEN_ANGLE) % 360;
                    let saturation = 0.65;
                    let lightness = 0.45;

                    let r, g, b;
                    let contrast = 0;

                    // try darker shades until contrast >= 4.5
                    while (lightness > 0.2) {
                        [r, g, b] = hslToRgb(hue, saturation, lightness);
                        contrast = contrastWithWhite(r, g, b);
                        if (contrast >= 4.5) break;
                        lightness -= 0.05;
                    }

                    colors.push(rgbToHex(r, g, b));
                }

                return colors;
            }
        },
        watch: {
            $route: {
                immediate: true,
                handler(to, from) {
                    this.event = null;
                    if (this.timer)
                        clearTimeout(this.timer)
                    this.fetchScoreSheet();
                }
            }
        },
        methods: {
            fetchScoreSheet() {
                // fetch scoreSheet from backend
                if (this.$route.params.eventSlug) {
                    $.ajax({
                        url: `${this.$store.getters.appURL}/${this.$store.getters['auth/getUser'].userType}.php`,
                        type: 'GET',
                        xhrFields: {
                            withCredentials: true
                        },
                        data: {
                            getScoreSheet: this.$route.params.eventSlug
                        },
                        success: (data) => {
                            data = JSON.parse(data);
                            this.criteria = data.criteria;
                            this.teams = data.teams;
                            this.ratings = data.ratings;
                            this.event = data.event;
                            this.totals = {}
                            // create total score for ratings
                            for (let i = 0; i < this.teams.length; i++) {
                                let total = 0;
                                this.totals[`team_${this.teams[i].id}`] = {};
                                const rating = this.ratings[`${this.event.slug}_${this.teams[i].id}`];
                                for (let j = 0; j < this.criteria.length; j++) {
                                    const criterion = this.criteria[j];
                                    const value = rating[`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${this.teams[i].id}`].value
                                    this.totals[`team_${this.teams[i].id}`].is_locked = rating[`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${this.teams[i].id}`].is_locked
                                    total += value;
                                }
                                this.totals[`team_${this.teams[i].id}`].value = parseFloat(total.toFixed(2));
                                this.totals[`team_${this.teams[i].id}`].loading = false;
                            }

                            // send active event to websocket server
                            this.websocketSend(
                                '__active_event__',
                                {
                                    event_id: data.event?.id
                                }
                            );
                        },
                        error: (error) => {
                            alert(`ERROR ${error.status}: ${error.statusText}`);
                        },
                    });
                }
            },
            handleRatingKeyUp(team) {
                // initialize total
                let total = 0;

                // accumulate ratings to total score
                const teamRating = this.ratings[`${this.event.slug}_${team.id}`];
                for (let i = 0; i < this.criteria.length; i++) {
                    const criterion = this.criteria[i];
                    total += Number(teamRating[`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value);
                }

                // accumulate total adds into totals object
                this.totals[`team_${team.id}`].value = parseFloat(total.toFixed(2));
            },
            saveRating(rating, percentage, team) {
                this.totals[`team_${team.id}`].loading = true;

                // validate rating
                if (rating.value < 0 || rating.value === '')
                    rating.value = 0;
                else if (rating.value > percentage)
                    rating.value = percentage;

                // round off rating
                rating.value = parseFloat(parseFloat(rating.value).toFixed(2));

                // handle rating keyup
                this.handleRatingKeyUp(team);

                // auto-save ratings
                $.ajax({
                    url: `${this.$store.getters.appURL}/${this.$store.getters['auth/getUser'].userType}.php`,
                    type: 'POST',
                    xhrFields: {
                        withCredentials: true
                    },
                    data: {
                        rating
                    },
                    success: (data, textStatus, jqXHR) => {
                        // set timeout for loading
                        if (this.totals[`team_${team.id}`].loading) {
                            setTimeout(() => {
                                this.totals[`team_${team.id}`].loading = false;
                            }, 1000);
                        }
                    },
                    error: (error) => {
                        alert(`ERROR ${error.status}: ${error.statusText}`);
                    }
                });
            },
            calculateTotalScores(team) {
                // set loading state
                this.totals[`team_${team.id}`].loading = true;

                // validates total scores
                if (this.totals[`team_${team.id}`].value < this.minRating || this.totals[`team_${team.id}`].value === '') {
                    this.totals[`team_${team.id}`].value = this.minRating;
                } else if (this.totals[`team_${team.id}`].value > this.maxRating) {
                    this.totals[`team_${team.id}`].value = this.maxRating;
                }

                // round off total
                const enteredTotal = parseFloat(this.totals[`team_${team.id}`].value.toFixed(2));
                this.totals[`team_${team.id}`].value = enteredTotal;

                // total score divided and distributed based on criteria percentage
                let ratings  = [];
                let newTotal = 0;
                for (let criterion of this.criteria) {
                    const rating = this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`];
                    rating.value = parseFloat((this.totals[`team_${team.id}`].value * (criterion.percentage / this.totalCriteriaPercentage)).toFixed(2));
                    ratings.push(rating);
                    newTotal += rating.value;
                }

                // write back total for precision
                if (newTotal !== enteredTotal) {
                    const discrepancy = parseFloat((enteredTotal - newTotal).toFixed(2));
                    let discrepancyRemainder = discrepancy;
                    // distribute the discrepancy to criteria ratings that are not yet full
                    for (let criterion of this.criteria) {
                        const rating = this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`];
                        rating.value += discrepancyRemainder;
                        rating.value = parseFloat(rating.value.toFixed(2));
                        if (rating.value > criterion.percentage) {
                            discrepancyRemainder = parseFloat((rating.value - criterion.percentage).toFixed(2));
                            rating.value = criterion.percentage;
                        }
                        else {
                            discrepancyRemainder = 0;
                        }
                        if (discrepancyRemainder <= 0) {
                            break;
                        }
                    }
                }

                // auto-save total score
                $.ajax({
                    url: `${this.$store.getters.appURL}/${this.$store.getters['auth/getUser'].userType}.php`,
                    type: 'POST',
                    xhrFields: {
                        withCredentials: true
                    },
                    data: {
                        ratings
                    },
                    success: (data, textStatus, jqXHR) => {
                        if (this.totals[`team_${team.id}`].loading) {
                            setTimeout(() => {
                                this.totals[`team_${team.id}`].loading = false;
                            }, 1000);
                        }
                    },
                    error: (error) => {
                        alert(`ERROR ${error.status}: ${error.statusText}`);
                    }
                });
            },
            openSubmitDialog() {
                // open dialog according to ratings
                for (let i = 0; i < this.teams.length; i++) {
                    if (!this.teams[i].disabled && (this.totalErrors[`team_${this.teams[i].id}`].empty || this.totalErrors[`team_${this.teams[i].id}`].invalid)) {
                        this.inspectDialog = true
                        this.submitDialog = false;
                        break;
                    } else {
                        this.submitDialog = true
                    }
                }
            },
            closeInspectDialog() {
                this.inspectDialog = false;
                this.$nextTick(() => {
                    for(let i=0; i<this.teams.length; i++) {
                        const team = this.teams[i];
                        if(this.totalErrors[`team_${team.id}`]) {
                            if(!team.disabled && (this.totalErrors[`team_${team.id}`].empty || this.totalErrors[`team_${team.id}`].invalid)) {
                                const inputTotal = this.$refs[`txt-total-${team.id}`];
                                if(inputTotal)
                                    inputTotal[0].focus();
                                /*const trTeam = $(`#row--team-${team.id}`);
                                if(trTeam.length > 0) {
                                    const tableWrapper = trTeam.closest('.v-table__wrapper');
                                    if(tableWrapper.length > 0) {
                                        tableWrapper.animate({
                                            scrollTop: trTeam.offset().top
                                        }, 300);
                                    }
                                }*/
                                break;
                            }
                        }
                    }
                });
            },
            submitRatings() {
                // set loading state
                this.submitLoading = true;

                // prepare ratings array
                let ratings = [];
                for (let i = 0; i < this.teams.length; i++) {
                    const team = this.teams[i];
                    for (let criterion of this.criteria) {
                        const rating = this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`];
                        ratings.push(rating);
                    }
                }

                // send data
                $.ajax({
                    url: `${this.$store.getters.appURL}/${this.$store.getters['auth/getUser'].userType}.php`,
                    type: 'POST',
                    xhrFields: {
                        withCredentials: true
                    },
                    data: {
                        ratings,
                        locking: true
                    },
                    success: (data, textStatus, jqXHR) => {
                        if (this.submitLoading) {
                            setTimeout(() => {
                                this.submitLoading = false
                                this.submitDialog = false;

                                // lock all ratings after submission
                                for (let i = 0; i < ratings.length; i++) {
                                    ratings[i].is_locked = true;
                                }

                                // lock all total scores for each rating
                                for (let i = 0; i < this.teams.length; i++) {
                                    this.totals[`team_${this.teams[i].id}`].is_locked = true;
                                }
                            }, 600);
                        }
                    },
                    error: (error) => {
                        this.submitLoading = false
                        alert(`ERROR ${error.status}: ${error.statusText}`);
                    }
                })
            },
            move(x, y, callback, focus = true) {
                // move to input
                const nextInput = document.querySelector(`#input_${y}_${x}`);
                if (nextInput) {
                    if(nextInput.disabled) {
                        if(callback)
                            callback(x, y);
                    }
                    else {
                        if (focus)
                            nextInput.focus();
                        if (Number(nextInput.value) <= 0)
                            nextInput.select();
                    }
                }
            },
            moveDown(x, y) {
                // move to input below
                y += 1;
                if (y < this.teams.length)
                    this.move(x, y, this.moveDown);
            },
            moveUp(x, y) {
                // move to input above
                y -= 1;
                if (y >= 0)
                    this.move(x, y, this.moveUp);
            },
            moveRight(x, y) {
                // move to input to the right
                x += 1;
                if (x <= this.criteria.length)
                    this.move(x, y, this.moveRight);
            },
            moveLeft(x, y) {
                // move to input to the left
                x -= 1;
                if (x >= 0)
                    this.move(x, y, this.moveLeft);
            },
            updateCoordinates(x, y) {
                // get input coordinates
                this.coordinates.x = x;
                this.coordinates.y = y;
                this.move(x, y, null, false);

                // send active team and column to websocket server
                this.websocketSend(
                    '__active_team_column__',
                    {
                        team_id: this.teams[y]?.id || 0,
                        column : x
                    }
                );
            },
            handleToggleHelp(status) {
                this.websocketSend('__call_for_help__', { status: status });
            },
            openTieBreaker() {
                // extract ties from tieGroups
                this.tieBreaker.tieGroups = {};
                for (const rankKey in this.tieGroups) {
                    if (this.tieGroups[rankKey].length > 1) {
                        // prepare tieGroup
                        this.tieBreaker.tieGroups[rankKey] = {
                            fractionalR: parseFloat(rankKey.replace('rank_', '')),
                            slots      : [],
                            teams      : [],
                            result     : []
                        };
                        // get slots competing for
                        const start = this.tieBreaker.tieGroups[rankKey].fractionalR - (this.tieGroups[rankKey].length - 1) / 2;
                        for (let i = 0; i < this.tieGroups[rankKey].length; i++) {
                            this.tieBreaker.tieGroups[rankKey].slots.push(start + i);
                        }
                        // get teams involved
                        for (let i = 0; i < this.tieGroups[rankKey].length; i++) {
                            this.tieBreaker.tieGroups[rankKey].teams.push(this.teamsAssoc[this.tieGroups[rankKey][i]]);
                        }
                    }
                }

                // open tie breaker modal
                this.tieBreaker.loading = false;
                this.tieBreaker.opened  = true;
            },
            toRightTieBreaker(tieGroupKey, index) {
                const tieGroup = this.tieBreaker.tieGroups[tieGroupKey];
                if (tieGroup) {
                    if (tieGroup.teams[index]) {
                        const element = { ...tieGroup.teams[index] };
                        tieGroup.teams.splice(index, 1);
                        tieGroup.result.push(element);
                    }
                }
            },
            toLeftTieBreaker(tieGroupKey, index) {
                const tieGroup = this.tieBreaker.tieGroups[tieGroupKey];
                if (tieGroup) {
                    if (tieGroup.result[index]) {
                        const element = { ...tieGroup.result[index] };
                        tieGroup.result.splice(index, 1);
                        tieGroup.teams.push(element);
                    }
                }
            },
            sortUpTieBreaker(tieGroupKey, index) {
                const tieGroup = this.tieBreaker.tieGroups[tieGroupKey];
                if (tieGroup) {
                    if (index > 0) {
                        const temp = { ...tieGroup.result[index] };
                        tieGroup.result[index] = { ...tieGroup.result[index - 1] };
                        tieGroup.result[index - 1] = temp;
                    }
                }
            },
            sortDownBreaker(tieGroupKey, index) {
                const tieGroup = this.tieBreaker.tieGroups[tieGroupKey];
                if (tieGroup) {
                    if (index < (tieGroup.result.length - 1)) {
                        const temp = { ...tieGroup.result[index] };
                        tieGroup.result[index] = { ...tieGroup.result[index + 1] };
                        tieGroup.result[index + 1] = temp;
                    }
                }
            },
            closeTieBreaker() {
                this.tieBreaker.opened = false;
            },
            applyTieBreaker() {
                if (this.tieBreaker.loading || this.scoreSheetDisabled) {
                    return;
                }
                const adjustedRatings = [];
                this.tieBreaker.loading = true;
                for (const rankKey in this.tieBreaker.tieGroups) {
                    const tieGroup = this.tieBreaker.tieGroups[rankKey];
                    if (tieGroup.result.length > 0) {
                        // determine if all tie teams are involved
                        const isAllTiesInvolved = tieGroup.result.length === tieGroup.slots.length;

                        // determine the total rating that the group is tie with
                        const tieTotal = this.totals[`team_${tieGroup.result[0].id}`].value;

                        // determine algorithm (default is increment)
                        let increment = true;
                        if (tieTotal >= this.totalCriteriaPercentage) {
                            increment = false;
                        }

                        // algorithm delta
                        const delta = 0.01;

                        // adjust team totals so that it's still within criteria percentage
                        let adjustment = 0;
                        if (increment) {
                            const lastTotal = (tieTotal + (delta * (isAllTiesInvolved ? (tieGroup.result.length - 1) : tieGroup.result.length)));
                            if (lastTotal > this.totalCriteriaPercentage) {
                                adjustment = parseFloat((lastTotal - this.totalCriteriaPercentage).toFixed(2));
                            }
                        }
                        else {
                            const lastTotal = (tieTotal - (delta * (isAllTiesInvolved ? (tieGroup.result.length - 1) : tieGroup.result.length)));
                            if (lastTotal < 0) {
                                adjustment = parseFloat((lastTotal * -1).toFixed(2));
                            }
                        }
                        if (adjustment > 0) {
                            adjustment = parseFloat(adjustment.toFixed(2));
                            for (let i = 0; i < tieGroup.result.length; i++) {
                                const team = tieGroup.result[i];
                                let adjustmentRemainder = adjustment;
                                for (let j = 0; j < this.criteria.length; j++) {
                                    const criterion = this.criteria[j];
                                    const rating = this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`];
                                    if (rating) {
                                        if (increment) {
                                            let adjustedRatingValue = rating.value - adjustmentRemainder;
                                            if (adjustedRatingValue < 0) {
                                                adjustmentRemainder = adjustedRatingValue * -1;
                                                adjustedRatingValue = 0;
                                            }
                                            else {
                                                adjustmentRemainder = 0;
                                            }
                                            this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value = adjustedRatingValue;
                                        }
                                        else {
                                            const adjustedRatingValue = rating.value + adjustmentRemainder;
                                            if (adjustedRatingValue > criterion.percentage) {
                                                adjustmentRemainder = adjustedRatingValue - criterion.percentage;
                                            }
                                            else {
                                                adjustmentRemainder = 0;
                                            }
                                            this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value = adjustedRatingValue;
                                        }
                                    }
                                    if (adjustmentRemainder <= 0) {
                                        break;
                                    }
                                }
                            }
                        }

                        // apply delta
                        if (increment) {
                            let activeDelta = delta * (isAllTiesInvolved ? (tieGroup.result.length - 1) : tieGroup.result.length);
                            for (let i = 0; i < tieGroup.result.length; i++) {
                                const team = tieGroup.result[i];
                                let activeDeltaRemainder = activeDelta;
                                for (let j = 0; j < this.criteria.length; j++) {
                                    const criterion = this.criteria[j];
                                    const rating = this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`];
                                    if (rating) {
                                        let adjustedRatingValue = parseFloat((rating.value + activeDeltaRemainder).toFixed(2));
                                        if (adjustedRatingValue > criterion.percentage) {
                                            adjustedRatingValue = criterion.percentage;
                                            activeDeltaRemainder = adjustedRatingValue - criterion.percentage;
                                        }
                                        else {
                                            activeDeltaRemainder = 0;
                                        }
                                        this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value = adjustedRatingValue;
                                    }

                                    // push rating to adjustedRatings
                                    adjustedRatings.push(this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`]);

                                    if (activeDeltaRemainder <= 0) {
                                        break;
                                    }
                                }

                                // update frontend ratings
                                this.handleRatingKeyUp(team);
                                this.totals[`team_${team.id}`].loading = true;

                                // next delta
                                activeDelta -= delta;
                            }
                        }
                        else {
                            let activeDelta = delta;
                            for (let i = 0; i < tieGroup.result.length; i++) {
                                const team = tieGroup.result[i];
                                let activeDeltaRemainder = activeDelta;
                                for (let j = 0; j < this.criteria.length; j++) {
                                    const criterion = this.criteria[j];
                                    const rating = this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`];
                                    if (rating) {
                                        let adjustedRatingValue = parseFloat((rating.value - activeDeltaRemainder).toFixed(2));
                                        if (adjustedRatingValue < 0) {
                                            adjustedRatingValue  = 0;
                                            activeDeltaRemainder = adjustedRatingValue * -1;
                                        }
                                        else {
                                            activeDeltaRemainder = 0;
                                        }
                                        this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`].value = adjustedRatingValue;
                                    }

                                    // push rating to adjustedRatings
                                    adjustedRatings.push(this.ratings[`${this.event.slug}_${team.id}`][`${this.$store.getters['auth/getUser'].id}_${criterion.id}_${team.id}`]);

                                    if (activeDeltaRemainder <= 0) {
                                        break;
                                    }
                                }

                                // update frontend ratings
                                this.handleRatingKeyUp(team);
                                this.totals[`team_${team.id}`].loading = true;

                                // next delta
                                activeDelta += delta;
                            }
                        }
                    }
                }

                // save adjusted ratings
                if (adjustedRatings.length > 0) {
                    $.ajax({
                        url: `${this.$store.getters.appURL}/${this.$store.getters['auth/getUser'].userType}.php`,
                        type: 'POST',
                        xhrFields: {
                            withCredentials: true
                        },
                        data: {
                            ratings: adjustedRatings
                        },
                        success: (data, textStatus, jqXHR) => {
                            for (const rankKey in this.tieBreaker.tieGroups) {
                                const tieGroup = this.tieBreaker.tieGroups[rankKey];
                                for (let i = 0; i < tieGroup.result.length; i++) {
                                    const team = tieGroup.result[i];
                                    if (this.totals[`team_${team.id}`].loading) {
                                        setTimeout(() => {
                                            this.totals[`team_${team.id}`].loading = false;
                                        }, 1000);
                                    }
                                }
                            }
                            this.tieBreaker.loading = false;
                        },
                        error: (error) => {
                            this.tieBreaker.loading = false;
                            alert(`ERROR ${error.status}: ${error.statusText}`);
                        }
                    });
                }

                this.closeTieBreaker();
            },
            handleSignOut() {
                this.websocketSend('__sign_out__');
            },
            websocketSend(action, payload) {
                if (this.ws !== null && this.ws.readyState === WebSocket.OPEN) {
                    this.ws.send(JSON.stringify({
                        competition: this.competition,
                        entity     : 'judge',
                        id         : this.$store.getters['auth/getUser']?.id,
                        action     : action,
                        payload    : payload
                    }));
                }
            }
        },
        created() {
            // initialize websocket connection
            this.competition = import.meta.env.BASE_URL.replaceAll('/', '');
            this.ws = new WebSocket(`${this.$store.getters['websocketUrl']}?competition=${this.competition}&entity=judge&id=${this.$store.getters['auth/getUser']?.id}`);

            // handle websocket open
            this.ws.onopen = () => {

            };

            // handle websocket message
            this.ws.onmessage = (e) => {
                let data = {};
                try { data = JSON.parse(e.data); } catch (e) {}

                if ('subject' in data && 'body' in data) {
                    const subject = data.subject;
                    const body    = data.body;

                    // receive help status
                    if (subject === '__help_status__') {
                        const user = this.$store.getters['auth/getUser'];
                        user.calling = !body;
                        this.$refs['top-nav'].toggleHelp();
                    }
                }
            };

            // handle websocket close
            this.ws.onclose = () => {

            };
        },
        mounted() {
            this.$emit('startPing');
        }
    }
</script>

<style>
    .transparent-tooltip {
        background-color: transparent !important;
        box-shadow: none !important;
        padding: 0 !important;
    }
</style>

<style scoped>
    tbody td, th {
        height: 64px !important;
    }

    tbody td {
        border-bottom: 1px solid #ddd;
        padding-top: 9px !important;
        padding-bottom: 9px !important;
    }

    #warning {
        animation: tilt-shaking 1ms linear infinite;
    }

    #remind {
        animation: tilt-shaking 1s linear infinite;
    }

    @keyframes tilt-shaking {
        0% {
            transform: rotate(0deg);
        }
        25% {
            transform: rotate(6deg);
        }
        50% {
            transform: rotate(0deg);
        }
        75% {
            transform: rotate(-6deg);
        }
        100% {
            transform: rotate(0deg);
        }
    }

    @keyframes shine {
        0% {
            background-position: 0% 50%;
        }
        50% {
            background-position: 100% 50%;
        }
        100% {
            background-position: 0% 50%;
        }
    }

    .avatar:hover {
        transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        box-shadow: 0 4px 8px rgba(10, 10, 10, 0.75);
    }

    .avatar-hover-effect:hover {
        transform: scale(1.2);
        transition: transform 0.3s ease;
    }
</style>