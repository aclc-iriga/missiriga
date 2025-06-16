<template id="judges-table"><div style="display: contents;">
<!-------------------------------------------------------->

    <table class="table sticky-top">
        <thead class="bg-white">
            <tr>
                <th style="width: 30%" class="text-center p-0">
                    <div class="d-flex px-1">
                        <span class="flex-grow-1">
                            <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>JUDGES
                        </span>
                        <div class="dropdown flex-grow-0 flex-shrink-0">
                            <button
                                id="btn-judges-dropdown-toggle"
                                class="btn btn-outline-secondary dropdown-toggle btn-sm no-caret p-0 border-0"
                                style="padding-left: 1px !important; padding-right: 1px !important; opacity: 0.55"
                                type="button"
                                data-bs-toggle="dropdown"
                                data-bs-auto-close="outside"
                            >
                                <i class="fas fa-fw fa-caret-down"></i>
                            </button>

                            <ul class="dropdown-menu">
                                <li class="px-3 pb-1 fw-normal text-secondary">
                                    <small style="font-size: 0.8rem; opacity: 0.9">TOGGLE SCREENSAVER</small>
                                </li>
                                <li>
                                    <button
                                        class="dropdown-item text-secondary btn-dropdown fw-bold"
                                        @click="$emit('toggle-screensaver-all', { status: true, judgeKeys: visible.items })"
                                        :disabled="!hasOnlineJudge"
                                        :style="{ 'opacity': hasOnlineJudge ? '1' : '0.5' }"
                                    >
                                        <i class="fas fa-fw fa-eye"></i> Show Screensaver
                                    </button>
                                </li>
                                <li>
                                    <button
                                        class="dropdown-item text-secondary btn-dropdown fw-bold"
                                        @click="$emit('toggle-screensaver-all', { status: false, judgeKeys: visible.items })"
                                        :disabled="!hasOnlineJudge"
                                        :style="{ 'opacity': hasOnlineJudge ? '1' : '0.5' }"
                                    >
                                        <i class="fas fa-fw fa-eye-slash"></i> Hide Screensaver
                                    </button>
                                </li>
                                <li><hr></li>
                                <li class="px-3 pb-1 fw-normal text-secondary">
                                    <small style="font-size: 0.8rem; opacity: 0.9">SET ACTIVE EVENT / PORTION</small>
                                </li>
                                <li v-for="([eventKey, event], eventIndex) in Object.entries(events)" :key="event.id">
                                    <button
                                        class="dropdown-item text-secondary btn-dropdown fw-bold"
                                        @click="$emit('switch-event-all', { event: event, judgeKeys: visible.items })"
                                        :disabled="!hasOnlineJudge"
                                        :style="{ 'opacity': hasOnlineJudge ? '1' : '0.5' }"
                                    >
                                        <i class="fas fa-fw fa-bars-progress"></i> {{ event.title }}
                                    </button>
                                </li>
                                <li><hr></li>
                                <li class="px-3 pb-1 fw-normal text-secondary">
                                    <small style="font-size: 0.8rem; opacity: 0.9">SHOW / HIDE JUDGES</small>
                                </li>
                                <li
                                    v-for="([judgeKey, judge], judgeIndex) in Object.entries(judges)"
                                    :key="judge.id"
                                >
                                    <label
                                        class="dropdown-item d-flex align-items-center btn-dropdown"
                                        style="cursor: pointer; user-select: none; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none;"
                                        :style="{ 'opacity': isJudgeVisible(judgeKey) ? '1' : '0.6' }"
                                    >
                                        <input
                                            class="form-check-input me-2"
                                            type="checkbox"
                                            :checked="isJudgeVisible(judgeKey)"
                                            @click.stop="toggleJudgeVisibility(judgeKey)"
                                        >
                                        <b class="opacity-75">JUDGE #{{ judge.number }}:</b>&nbsp;{{ judge.name }}
                                    </label>
                                </li>
                            </ul>
                        </div>
                    </div>
                </th>
                <th style="width: 45%" class="text-center">CANDIDATE</th>
                <th style="width: 25%" class="text-center">EVENT</th>
            </tr>
        </thead>

        <tbody class="bg-white">
            <tr
                v-for="([judgeKey, judge], judgeIndex) in Object.entries(processedJudges)"
                :key="judge.id"
                :class="{ 'table-danger': !judge.online, 'help-blink': judge.helpStatus }"
            >
                <template v-if="judge.visible">
                    <td class="text-center p-0">
                        <div
                            class="d-flex justify-content-center align-items-center"
                            style="height: 115px; border-right: 8px solid transparent; transition: border-left 0.3s ease"
                            :style="{ 'border-left': judge.onScreenSaver ? '8px solid rgb(222, 226, 230)' : '8px solid transparent' }"
                        >
                            <div>
                                <div style="margin-bottom: 8px;">
                                    <h6 class="m-0" style="font-size: 0.9rem;">JUDGE #{{ judge.number }}</h6>
                                    <p class="m-0" style="line-height: 1; font-size: 0.9rem; opacity: 0.8; margin-top: 4px !important;">{{ judge.name }}</p>
                                </div>
                                <div class="dropdown d-inline">
                                    <p
                                        class="dropdown-toggle no-caret m-0 p-0 fw-bold opacity-75"
                                        :class="!judge.helpStatus ? `text-${judge.statusClass}` : ''"
                                        style="font-size: 0.7rem; cursor: pointer;"
                                        data-bs-toggle="dropdown"
                                        role="button"
                                        aria-expanded="false"
                                    >
                                        {{ judge.statusText }}
                                        <i class="fas fa-fw fa-caret-down" v-if="judge.online || judge.helpStatus"></i>
                                    </p>
                                    <ul class="dropdown-menu" v-show="judge.online || judge.helpStatus">
                                        <li class="py-1 fw-bold" style="font-size: 0.8rem; opacity: 0.8">
                                            <div class="d-flex justify-content-between align-items-center px-3">
                                                <span>JUDGE #{{ judge.number }}</span>
                                                <i class="fas fa-fw fa-remove" style="cur" onclick="event.stopPropagation();bootstrap.Dropdown.getOrCreateInstance(this.closest('.dropdown')).hide()"></i>
                                            </div>
                                        </li>
                                        <li v-if="judge.onScreenSaver">
                                            <button class="dropdown-item btn-dropdown text-secondary" @click="$emit('toggle-screensaver', { judge: judge, status: false })">
                                                <small class="fw-bold">
                                                    <i class="fas fa-fw fa-eye-slash"></i> Hide Screensaver
                                                </small>
                                            </button>
                                        </li>
                                        <li v-else>
                                            <button class="dropdown-item btn-dropdown text-success" @click="$emit('toggle-screensaver', { judge: judge, status: true })">
                                                <small class="fw-bold">
                                                    <i class="fas fa-fw fa-eye"></i> Show Screensaver
                                                </small>
                                            </button>
                                        </li>
                                        <li v-if="judge.helpStatus">
                                            <button class="dropdown-item btn-dropdown" @click="$emit('terminate-help', judge.id)" style="color: orangered">
                                                <small class="fw-bold">
                                                    <i class="fas fa-fw fa-circle-question"></i> Terminate Help
                                                </small>
                                            </button>
                                        </li>
                                        <template v-if="judge.online">
                                            <li v-if="judge.events.length > 0" style="height: 15px;"></li>
                                            <li v-for="(eventKey, eventKeyIndex) in judge.events" :key="eventKey">
                                                <button
                                                    v-if="judge.activeEvent && judge.activeEvent.id === events[eventKey].id"
                                                    class="dropdown-item text-success btn-dropdown btn-dropdown-active"
                                                    @click="$emit('refresh-event', { judge: judge, event: events[eventKey] })"
                                                >
                                                    <small class="fw-bold">
                                                        <i class="fas fa-fw fa-rotate"></i> {{ events[eventKey].title }}
                                                    </small>
                                                </button>
                                                <button
                                                    v-else
                                                    class="dropdown-item text-primary btn-dropdown"
                                                    @click="$emit('switch-event', { judge: judge, event: events[eventKey] })"
                                                >
                                                    <small class="fw-bold">
                                                        <i class="fas fa-fw fa-bars-progress"></i> {{ events[eventKey].title }}
                                                    </small>
                                                </button>
                                            </li>
                                        </template>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </td>
                    <td>
                        <team-block v-if="judge.online && judge.activeTeam" :team="judge.activeTeam"></team-block>
                    </td>
                    <td class="text-center">
                        <div v-if="judge.online">
                            <p v-if="judge.activeEvent" class="fw-bold opacity-75 text-uppercase m-0" style="font-size: 0.8rem;">
                                {{ judge.activeEvent.title }}
                            </p>
                            <p v-if="judge.activeTeam && judge.activeEvent" class="m-0" style="line-height: 1; margin-top: 8px !important;">
                                <template v-if="judge.activeEvent.criteria[judge.activeColumn]">
                                    <span style="font-size: 0.7rem; font-weight: bold; opacity: 0.8">Field #{{ judge.activeColumn + 1 }}</span><br/>
                                    <span style="font-size: 0.75rem;">{{ judge.activeEvent.criteria[judge.activeColumn].title }}</span><br/>
                                    <span style="font-size: 0.8rem;">{{ judge.activeEvent.criteria[judge.activeColumn].percentage }}%</span>
                                </template>
                                <template v-else-if="judge.activeColumn >= judge.activeEvent.criteria.length">
                                    <span style="font-size: 0.7rem; font-weight: bold; opacity: 0.8">Field #{{ judge.activeColumn + 1 }}</span><br/>
                                    <span style="font-size: 0.75rem;">TOTAL</span><br/>
                                    <span style="font-size: 0.8rem;">{{ judge.activeEvent.criteria_total }}%</span>
                                </template>
                            </p>
                        </div>
                    </td>
                </template>
            </tr>
        </tbody>
    </table>

<!-------------------------------------------------------->
</div></template>

<script>
    window.JudgesTable = {
        /** TEMPLATE */
        template: `#judges-table`,


        /** COMPONENTS */
        components: {
            TeamBlock
        },


        /** PROPS */
        props: {
            competition: {
                type: String,
                required: true
            },

            judges: {
                type: Object,
                required: true
            },

            events: {
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
            },

            judgesOnScreensaver: {
                type: Array,
                required: true
            },

            teams: {
                type: Object,
                required: true
            }
        },


        /** DATA */
        data() {
            return {
                visible: {
                    key  : 'dashboard-judges',
                    items: []
                }
            }
        },


        /** COMPUTED */
        computed: {
            /**
             * @computed processedJudges
             * @description Judge objects with injected data.
             * @returns {Object}
             */
            processedJudges() {
                const judges = { ...this.judges };
                for (const judgeKey in judges) {
                    // judge online status
                    const isOnline  = this.judgesOnline.includes(judgeKey);
                    let statusText  = 'OFFLINE';
                    let statusClass = 'danger';
                    if (isOnline) {
                        statusText  = 'ONLINE';
                        statusClass = 'success';
                    }

                    // judge active event
                    let activeEventKey = '';
                    let activeEvent    = null;
                    if (judgeKey in this.judgesEvent) {
                        activeEventKey = this.judgesEvent[judgeKey] || '';
                    }
                    if (activeEventKey in this.events) {
                        activeEvent = this.events[activeEventKey];
                    }

                    // judge active team and column
                    let activeTeamKey = '';
                    let activeColumn  = 0;
                    let activeTeam    = null;
                    if (judgeKey in this.judgesTeamColumn) {
                        activeTeamKey   = this.judgesTeamColumn[judgeKey].team || '';
                        activeColumn = this.judgesTeamColumn[judgeKey].column  || 0;
                    }
                    if (activeTeamKey in this.teams) {
                        activeTeam = this.teams[activeTeamKey];
                    }

                    // judge help request status
                    const helpStatus = this.judgesForHelp.includes(judgeKey);
                    if (helpStatus) {
                        statusText += ': HELP';
                    }

                    judges[judgeKey] = {
                        ...judges[judgeKey],
                        online        : isOnline,
                        statusText    : statusText,
                        statusClass   : statusClass,
                        activeEventKey: activeEventKey,
                        activeEvent   : activeEvent,
                        activeTeamKey : activeTeamKey,
                        activeTeam    : activeTeam,
                        activeColumn  : activeColumn,
                        helpStatus    : helpStatus,
                        onScreenSaver : this.judgesOnScreensaver.includes(judgeKey),
                        visible       : this.isJudgeVisible(judgeKey)
                    }
                }

                return judges;
            },

            /**
             * @computed hasOnlineJudge
             * @desription There's an online judge.
             * @returns {boolean}
             */
            hasOnlineJudge() {
                let online = false;
                for (const judgeKey in this.processedJudges) {
                    online = this.processedJudges[judgeKey].online && this.processedJudges[judgeKey].visible;
                    if (online) {
                        break;
                    }
                }

                return online;
            }
        },


        /** WATCHERS */
        watch: {

        },


        /** METHODS */
        methods: {
            /**
             * @method storeVisibleJudges
             * @description Store the visible judges to local storage.
             */
            storeVisibleJudges() {
                localStorage.setItem(`${this.competition}-${this.visible.key}`, JSON.stringify(this.visible.items));
            },

            /**
             * @method retrieveVisibleJudges
             * @description Retrieve the visible judges from local storage.
             */
            retrieveVisibleJudges() {
                const visibleJudges = localStorage.getItem(`${this.competition}-${this.visible.key}`);
                if (visibleJudges) {
                    let items = null;
                    try { items = JSON.parse(visibleJudges); } catch (e) {}
                    if (items) {
                        this.visible.items = items;
                        for (const judgeKey in this.judges) {
                            this.judges[judgeKey]['visible'] = this.visible.items.includes(judgeKey);
                        }
                    }
                }
            },

            /**
             * @method addVisibleJudge
             * @description Add visible judge.
             * @param {string} judgeKey
             */
            addVisibleJudge(judgeKey) {
                if (!(this.visible.items.includes(judgeKey))) {
                    this.visible.items.push(judgeKey);
                    this.judges[judgeKey].visible = true;
                    this.storeVisibleJudges();
                }
            },

            /**
             * @method removeVisibleJudge
             * @description Remove visible judge.
             * @param {string} judgeKey
             */
            removeVisibleJudge(judgeKey) {
                const index = this.visible.items.indexOf(judgeKey);
                if (index !== -1) {
                    this.visible.items.splice(index, 1);
                    this.judges[judgeKey].visible = false;
                    this.storeVisibleJudges();
                }
            },

            /**
             * @method isJudgeVisible
             * @description Checks if judge is visible.
             * @param judgeKey
             * @returns {boolean}
             */
            isJudgeVisible(judgeKey) {
                return this.visible.items.includes(judgeKey);
            },

            /**
             * @method toggleJudgeVisibility
             * @description Toggle judge visibility.
             * @param {string} judgeKey
             */
            toggleJudgeVisibility(judgeKey) {
                if (this.isJudgeVisible(judgeKey)) {
                    this.removeVisibleJudge(judgeKey);
                }
                else {
                    this.addVisibleJudge(judgeKey);
                }
            }
        },


        /** CREATED HOOK */
        created() {
            // initialize visible judges
            this.visible.items = Object.keys(this.judges);
        },


        /** MOUNTED HOOK */
        mounted() {
            this.$nextTick(() => {
                // retrieve the visible judges from local storage
                this.retrieveVisibleJudges();
            });
        },


        /** BEFORE UNMOUNT HOOK*/
        beforeUnmount() {

        }
    };
</script>