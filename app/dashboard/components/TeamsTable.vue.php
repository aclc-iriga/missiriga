<template id="teams-table"><div style="display: contents;">
<!-------------------------------------------------------->

    <table class="table table-hover table-bordered bg-white">
        <thead class="sticky-top bg-white">
            <!-- thead row 1 -->
            <tr>
                <!-- Event Title -->
                <th colspan="2" rowspan="2" class="text-center">
                    <h2 class="p-0 m-0 text-uppercase">{{ event.title }}</h2>
                </th>

                <!-- Criteria Title -->
                <th
                    v-for="(criterion, criterionIndex) in event.criteria"
                    :key="criterion.id"
                    class="text-center"
                    :style="{ 'width': `${73/(event.criteria.length + 1)}%` }"
                >
                    {{ criterion.title }}
                </th>

                <!-- Total Title -->
                <th class="text-center" :style="{ 'width': `${73/(event.criteria.length + 1)}%` }">TOTAL</th>
            </tr>

            <!-- thead row 2 -->
            <tr>
                <!-- Criteria Percentage -->
                <th
                    v-for="(criterion, criterionIndex) in event.criteria"
                    :key="criterion.id"
                    class="text-center"
                >
                    {{ criterion.percentage }}%
                </th>

                <!-- Criteria Total -->
                <th class="text-center">{{ event.criteria_total }}%</th>
            </tr>
        </thead>

        <tbody class="bg-white">
            <tr
                v-for="([teamKey, team], index) in Object.entries(processedTeams)"
                :key="team.id"
            >
                <!-- Candidate No. -->
                <td class="text-center">
                    <h3 class="m-0 p-0">{{ team.number }}</h3>
                </td>

                <!-- Candidate -->
                <td class="py-3">
                    <team-block :team="team" avatar-size="54" no-number></team-block>
                </td>

                <!-- Criteria Judges -->
                <td
                    v-for="(criterion, criterionIndex) in event.criteria"
                    :key="criterion.id"
                >
                    <div class="d-flex justify-content-center align-items-center flex-wrap gap-2">
                        <template v-if="team.judgeData.length > 0">
                            <div v-for="(judgeDatum, judgeDatumIndex) in team.judgeData">
                                <judge-avatar
                                    v-if="judgeDatum.column === criterionIndex"
                                    :judge="judgeDatum.judge"
                                    :help-status="judgeDatum.helpStatus"
                                >
                                </judge-avatar>
                            </div>
                        </template>
                    </div>
                </td>

                <!-- Total Judges -->
                <td>
                    <div class="d-flex justify-content-center align-items-center gap-2">
                        <template v-if="team.judgeData.length > 0">
                            <div v-for="(judgeDatum, judgeDatumIndex) in team.judgeData">
                                <judge-avatar
                                    v-if="judgeDatum.column >= event.criteria.length"
                                    :judge="judgeDatum.judge"
                                    :help-status="judgeDatum.helpStatus"
                                >
                                </judge-avatar>
                            </div>
                        </template>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>

<!-------------------------------------------------------->
</div></template>

<script>
    window.TeamsTable = {
        /** TEMPLATE */
        template: `#teams-table`,


        /** COMPONENTS */
        components: {
            TeamBlock,
            JudgeBlock,
            JudgeAvatar
        },


        /** PROPS */
        props: {
            teams: {
                type: Object,
                required: true
            },

            event: {
                type: Object,
                required: true
            },

            judges: {
                type: Object,
                required: true
            },

            judgesOnline: {
                type: Array,
                required: true
            },

            judgesEvent: {
                type: Object,
                required: true
            },

            judgesTeamColumn: {
                type: Object,
                required: true
            },

            judgesForHelp: {
                type: Array,
                required: true
            }
        },


        /** DATA */
        data() {
            return {

            }
        },


        /** COMPUTED */
        computed: {
            /**
             * @computed processedTeams
             * @description Team objects with injected data.
             * @returns {Object}
             */
            processedTeams() {
                const teams = {};
                const eventJudges = {};
                for (let i = 0; i < this.judgesOnline.length; i++) {
                    const judgeKey = this.judgesOnline[i];
                    if (judgeKey in this.judgesEvent) {
                        if (this.judgesEvent[judgeKey] === `event_${this.event.id}`) {
                            if (judgeKey in this.judgesTeamColumn) {
                                const judgeTeamKey = this.judgesTeamColumn[judgeKey].team;
                                const judgeColumn  = this.judgesTeamColumn[judgeKey].column;
                                if (!(judgeTeamKey in eventJudges)) {
                                    eventJudges[judgeTeamKey] = [];
                                }
                                eventJudges[judgeTeamKey].push({
                                    column    : judgeColumn,
                                    judge     : this.judges[judgeKey],
                                    helpStatus: this.judgesForHelp.includes(judgeKey)
                                })
                            }
                        }
                    }
                }

                for (let i = 0; i < this.event.teams.length; i++) {
                    const teamKey = this.event.teams[i];
                    const team = { ...this.teams[teamKey] };
                    if (team) {
                        team.judgeData = [];
                        if (teamKey in  eventJudges) {
                            team.judgeData = eventJudges[teamKey];
                        }

                        teams[teamKey] = team;
                    }
                }

                return teams;
            }
        },


        /** WATCHERS */
        watch: {

        },


        /** METHODS */
        methods: {

        },


        /** CREATED HOOK */
        created() {

        },


        /** MOUNTED HOOK */
        mounted() {
            this.$nextTick(() => {

            });
        },


        /** BEFORE UNMOUNT HOOK*/
        beforeUnmount() {

        }
    };
</script>